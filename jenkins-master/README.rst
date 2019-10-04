==============
Jenkins Master
==============

This is a containerized Jenkins server that comes preconfigured with
the Jenkins Templating Engine and dependent plugins.

Hooks have been built in to allow customizations of the Jenkins
configuration of either the server itself or the jobs.

=============
Configuration
=============

Volumes
-------

This image can maintain configurations between restarts by attaching
a volume to the ``JENKINS_HOME`` directory at ``/var/jenkins_home``.

Jenkins Job Configurations
--------------------------

This image uses :ref:`Job DSL <https://github.com/jenkinsci/job-dsl-plugin/wiki>` to
automatically configure Jenkins Jobs upon container initialization.

All Job DSL scripts (ending with ``.groovy``) in the ``/var/jenkins_home/init.jobdsl.d``
directory will be executed on start.

There are two main methods for adding the Job DSL scripts:

Extending the Image
*******************

One strategy for adding the Job DSL Scripts would be to extend the image to copy
the scripts directly into the image.  Let's assume there's a directory called ``jobs``
in your docker build context; then you Dockerfile would look something like:

.. code::

    FROM <this image>
    COPY jobs/** $JENKINS_HOME/init.jobdsl.d/

Injecting Scripts at Run Time
*****************************

If this image is being hosted on Kubernetes, one option to add Job DSL
Scripts to the image would be to inject them at runtime.

This would be done with a ``ConfigMap`` defining the scripts that gets
defined as a volume on the container at ``/var/jenkins_home/init.jobdsl.d``

The benefit of this approach is that this allows you to update your Jenkins
Job configurations without having to rebuild the container image.

Jenkins Server Configuration
----------------------------

There are two primary methods for customizing the Jenkins Server
configuration of the image.

Jenkins Configuration as Code (JCasC)
*************************************

The favored way to automate your Jenkins configuration is to leverage the
JCasC Plugin (https://github.com/jenkinsci/configuration-as-code-plugin/blob/master/README.md).

In general, most plugins and configurations are supported via the YAML syntax.  Typically,
you can configure your Jenkins instance as desired and export the configuration to be polished
before preserving in your SCM.

Once you have your JCasC YAML - the same strategies for adding the Job DSL Scripts applies
to the JCasC YAML.  All the files located within ``/usr/share/jenkins/ref/casc_configs/``
will be parsed to configure the Jenkins instance.

Jenkins Init Groovy Scripts
***************************

For any configurations that can not be configured via JCasC, you can always leverage an
Init Groovy Script to configure Jenkins.  These scripts can modify Jenkins programmatically.

Any groovy file located within ``/usr/share/jenkins/ref/init_groovy`` will be executed when
Jenkins starts to configure the instance.

Once again, both the strategies of extending this image or injecting init groovy scripts into
the running container will work for customization.
