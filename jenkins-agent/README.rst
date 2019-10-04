=============
Jenkins Agent
=============

This is a containerized Jenkins Agent that leverages Docker-in-Docker
to enable the execution of arbitrary container images from a Jenkins
pipeline.

=============
Configuration
=============

Volumes
-------

It is suggested to attach a persistent volume to ``/var/lib/docker`` to give
the agent persistent docker storage.  This will considerably improve the
performance of building, pulling, and running container images from the agent.

Environment Variables
---------------------

.. csv-table::
   :header: "Variable", "Description"

    "JENKINS_URL", "The URL of your Jenkins Server"
    "JENKINS_TUNNEL", "Of the form <Jenkins Server Hostname>:<JNLP Port>"
    "JENKINS_USERNAME", "The Jenkins username used to authenticate" 
    "JENKINS_PASSWORD", "The password for the Jenkins user used to authenticate"
    "EXECUTORS", "The number of executors for this agent"
    "JAVA_OPTS", "Any additional Java options for the agent JVM"
