/*
  Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
  This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl
*/

import jenkins.*
import hudson.*
import hudson.util.Secret
import hudson.model.*
import jenkins.model.*
import hudson.security.*
import jenkins.security.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import com.cloudbees.plugins.credentials.CredentialsProvider
import hudson.plugins.sshslaves.*
import org.openshift.jenkins.plugins.openshiftlogin.OpenShiftOAuth2SecurityRealm
import com.openshift.jenkins.plugins.OpenShiftTokenCredentials
import com.openshift.jenkins.plugins.ClusterConfig
import groovy.io.FileType
import javaposse.jobdsl.dsl.DslScriptLoader
import javaposse.jobdsl.plugin.JenkinsJobManagement
import java.util.logging.Logger
import org.jenkinsci.plugins.github_branch_source.GitHubConfiguration
import org.jenkinsci.plugins.github_branch_source.Endpoint

// for shared libraries
import org.jenkinsci.plugins.workflow.libs.GlobalLibraries
import org.jenkinsci.plugins.workflow.libs.LibraryConfiguration
import org.jenkinsci.plugins.workflow.libs.SCMSourceRetriever
import org.jenkinsci.plugins.workflow.libs.SCMRetriever
import org.jenkinsci.plugins.github_branch_source.GitHubSCMSource
import hudson.plugins.filesystem_scm.FSSCM

// for security
import jenkins.security.s2m.AdminWhitelistRule
import hudson.security.csrf.DefaultCrumbIssuer
import org.jenkinsci.plugins.configfiles.groovy.GroovyScript
import org.jenkinsci.plugins.configfiles.GlobalConfigFiles
import org.jenkinsci.plugins.scriptsecurity.scripts.languages.GroovyLanguage
import jenkins.model.JenkinsLocationConfiguration
import org.jenkinsci.plugins.workflow.flow.FlowDurabilityHint

//for sonar installation
import hudson.plugins.sonar.SonarInstallation
import hudson.plugins.sonar.SonarRunnerInstallation
import hudson.plugins.sonar.SonarRunnerInstaller
import hudson.plugins.sonar.model.TriggersConfig
import hudson.tools.InstallSourceProperty


//////////////////////
// Define Constants //
//////////////////////

Boolean on_openshift = System.getenv("OPENSHIFT") ? true : false

def project_name, jenkins_secret
if (on_openshift){
  whoami = "oc whoami".execute()
  whoami.waitFor()
  project_name = whoami.text.split(":").getAt(2)

  jenkins_secret = "jenkins-access"
}

////////////////

def logger = Logger.getLogger("")
log = { message ->
  logger.info("${message}..")
}

log "found project to be: ${project_name}"

def jenkins = Jenkins.getInstance()

// master executors
def num_master_executors = 0
if (!on_openshift){ num_master_executors = 2 }
log "Setting master executors to ${num_master_executors}"
jenkins.setNumExecutors(num_master_executors)
jenkins.save()

// slave agent port
log "Setting agent port to 50000"
jenkins.setSlaveAgentPort(50000)
jenkins.save()

// durability set to performance optimized
durability = jenkins.getDescriptor("org.jenkinsci.plugins.workflow.flow.GlobalDefaultFlowDurabilityLevel")
durability.setDurabilityHint(FlowDurabilityHint.PERFORMANCE_OPTIMIZED)
jenkins.save()

// set jenkins url
if (on_openshift){
  log "setting Jenkins URL"
  route = "oc get route jenkins | tail -n +2 | '{print \$2}'".execute()
  route.waitFor()
  url = route.text
  jlc = new JenkinsLocationConfiguration().get()
  jlc.setUrl(url)
  jlc.save()


  // create dummy admin user for connection agents
  log "Creating admin service account: jenkins-admin"
  jenkins_dummy_user = "jenkins-admin"
  def user = hudson.model.User.get(jenkins_dummy_user)
  user.setFullName("Jenkins Administrator")
  dummy_pass = (1..20).collect([]){ ("a".."z").getAt(new Random().nextInt(26) % 26) }.join()
  user.addProperty(hudson.security.HudsonPrivateSecurityRealm.Details.fromPlainPassword(dummy_pass))

  // create dummy admin user api token and create openshift secret
  ApiTokenProperty t = user.getProperty(ApiTokenProperty.class)
  apitoken.ApiTokenStore.TokenUuidAndPlainValue tokenUuidAndPlainValue = t.tokenStore.generateNewToken('jenkins-access')
  def token = tokenUuidAndPlainValue.plainValue
  user.save()

  log "Creating OpenShift secret ${jenkins_secret} with admin service account API token"

  def proc1 = "oc delete secret ${jenkins_secret} || true".execute()
  proc1.waitFor()
  log proc1.text

  def proc2 = "oc create secret generic ${jenkins_secret} --from-literal=username=${jenkins_dummy_user} --from-literal=token=${token}".execute()
  proc2.waitFor()
  log proc2.text

  // create security matrix
  log "Creating authorization strategy to Global Matrix Authorization"
  GlobalMatrixAuthorizationStrategy newAuthMgr = new GlobalMatrixAuthorizationStrategy()

  // set default authenticated user permissions
  log "Setting default permissions for authenticated user"
  [
    Hudson.READ,
    Item.READ,
    Item.DISCOVER,
    CredentialsProvider.VIEW
  ].each{ permission ->
    log "  - ${permission}"
    newAuthMgr.add(permission, "authenticated");
  }

  // give dummy admin user ability to configure agents
  log "Giving permissions to jenkins admin service account"
  [
    Jenkins.ADMINISTER,
    hudson.model.Computer.BUILD,
    hudson.model.Computer.CONFIGURE,
    hudson.model.Computer.CONNECT,
    hudson.model.Computer.CREATE,
    hudson.model.Computer.DELETE,
    hudson.model.Computer.DISCONNECT,
    hudson.model.Computer.EXTENDED_READ
  ].each{ permission ->
    log "  - ${permission}"
    newAuthMgr.add(permission, jenkins_dummy_user)
  }

  // apply matrix auth
  log "Applying Global Matrix Authorization Strategy"
  jenkins.setAuthorizationStrategy(newAuthMgr)
  jenkins.save()

  // add openshift oauth realm
  log "Setting Security Realm to: OpenShiftOAuth2SecurityRealm"
  def secRealm = new OpenShiftOAuth2SecurityRealm(null, null, null, null, null, null);
  jenkins.setSecurityRealm(secRealm)
  jenkins.save()

  // create openshift clusters
  log "Creating OpenShift Service Account Secret in Jenkins Credential Store"
  def get_sa_token = "oc whoami -t".execute()
  get_sa_token.waitFor()
  sa_token = get_sa_token.text - '\n'
  def cred_obj_1 = new OpenShiftTokenCredentials(
    CredentialsScope.GLOBAL,
    "openshift-service-account",
    "OCP Jenkins Service Account API Token",
    new Secret(sa_token)
  )
  SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), cred_obj_1)

  log "Creating Openshift Docker Registry Secret in Jenkins Credential Store"
  def cred_obj_2 = (Credentials) new UsernamePasswordCredentialsImpl(
    CredentialsScope.GLOBAL,
    "openshift-docker-registry",
    "openshift-docker-registry",
    "service",
    sa_token
  )
  SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), cred_obj_2)


}

// optimize agents disconnecting post termination
log "Configuring optmized agent pod deregistration settings"
jenkins.injector.getInstance(hudson.slaves.ChannelPinger.class).@pingIntervalSeconds = 1
jenkins.injector.getInstance(hudson.slaves.ChannelPinger.class).@pingTimeoutSeconds = 10

// additional security settings
log "Turning on Agent -> Master Control"
jenkins.injector.getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)

log "Disabling CLI Over Remoting"
jenkins.CLI.get().setEnabled(false)

log "Enabling CSRF Protection"
jenkins.setCrumbIssuer(new DefaultCrumbIssuer(true))
jenkins.save()

log "Removing Deprecated Protocols"
def protocols = jenkins.AgentProtocol.all()
protocols.each{ p ->
  if (!(p.name in [ "Ping", "JNLP4-connect" ]))
    protocols.remove(p)
}
