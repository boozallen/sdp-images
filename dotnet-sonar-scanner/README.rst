-------------
dotnet-sonar-scanner
-------------

A container image that jenkins uses to run SonarQube analysis for .NET solutions.

JAVA_JDK_VERSION      - Version of Java JDK to install (required for sonar-scanner)
SONAR_SCANNER_VERSION - Version of .NET Sonar Scanner to install
COVERLET_VERSION      - Version of Coverlet to install

Synopsis
--------

  To implement this repo locally, copy the repo to your machine.
  From there open a command line, change your working directory to your copy of the repo, and use ``make build`` or ``docker build .`` to build the container image in the CLI.
  Once the image is built, create a container using ``docker run image``.

  The following sections are an explaination of the contents of repo.

Prereqs
-------

  This repo makes use of .NET 5 SDK as the base image for the container derived from `Microsoft <https://github.com/microsoft/containerregistry>`_.
  Additionally, this repo makes use of Docker for containers. If you do not wish to use Docker, please make edits to adapt to your implementation of container technology.
  Lastly, you should ensure all files from the repo are present in your local copy.

Makefile
--------

  The Makefile comes with the following commands: help, build, push, info.
  ``make help`` will list available commands from the Makefile.
  ``make build`` will build a container image using the Dockerfile in the repo with the tag comprised of the application and version (application:version).
  ``make push`` will build the container image and then publish the image to Github.
  ``make info`` will list the container registry and repo the image can be published to.
  .. note:: using ``make push`` provides no benefit by default to those outside of Booz Allen.

Dockerfile
----------

  This file is setup to generate a container image using ``docker build -t <TAG> .`` with the option to name the image as you wish.
  The build process will consist of using a base image, copying the Booz Allen Public License, applying OpenShift labels, installing required packages and applications, establishing the user the container will run as, and setting a health check.

LICENSE
-------

  This text file contains the Booz Allen Public License. Please read before using or distibuting this repo.