/*
  Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
  This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl
*/

@Library("solutions_delivery_platform@master") _

node{
  cleanWs()
  checkout scm 
  stash "workspace"
  stash name: "git-info",
        includes: ".git/**",
        useDefaultExcludes: false
  aggregate_pipeline_config()  
  pipeline_template = get_pipeline_template() 
}

load_libraries                   this
create_application_environments  this
create_stages                    this
create_jenkinsfile_variables     this
create_default_steps             this

// execute pipeline
try{
  evaluate pipeline_template
}
catch(ex){
  currentBuild.result = "Failure"
  println ex
}

// notify
pipeline_config().notifiers.each{ notifier ->
  try{
    this.getProperty(notifier)()
  }
  catch(any){
    println "Notifier ${notifier} failed"
    println ex
  }
}
