-------------
Jenkins Agent (``v.340``)
-------------

An updated Jenkins Agent container image based on the ``boozallen/sdp-images/jenkins-agent:3.23`` image using Jenkins Swarm Client ``v3.40`` and JNLP Slave ``v4.14``.
Due to recent changes to the RHEL and CentOS repositories, the original Jenkins Agent image is no longer able to be built using its Dockerfile.
This image is a temporary solution until the original Jenkins Agent image can be rebuilt.

Makefile
--------

  The Makefile comes with the following commands: help, build, push, build-dep, info.
  ``make help`` will list available commands from the Makefile.
  ``make build`` will build a container image using the Dockerfile in the repo with the tag comprised of the application and version (application:version).
  ``make publish`` will build the container image and then publish the image to Github.
  ``make info`` will list the container registry and repo the image can be published to.
  .. note:: using ``make publish`` provides no benefit by default to those outside of Booz Allen. Additionally, using ``make build-dep`` is unnecessary since the Dockerfile will obtain the needed tarball from Github.

Dockerfile
----------

  This file is setup to generate a container image using ``docker build -t <TAG> .`` with the option to name the image as you wish.
  The build process will consist of using a base image, copying the Booz Allen Public License, applying OpenShift labels, installing required packages and applications, establishing the user the container will run as, and setting a health check.

LICENSE
-------

  This text file contains the Booz Allen Public License. Please read before using or distibuting this repo.
