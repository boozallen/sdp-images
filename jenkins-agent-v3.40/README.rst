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
  .. note:: using ``make publish`` provides no benefit by default to those outside of Booz Allen.

Dockerfile
----------

  This file is setup to generate a container image using ``docker build -t <TAG> .`` with the option to name the image as you wish.

LICENSE
-------

  This text file contains the Booz Allen Public License. Please read before using or distibuting this repo.
