--------------
openshift_helm
--------------

A container image that jenkins uses to authenticate to OpenShift and perform a
deployment through `Helm <https://helm.sh>`_

Synopsis
--------

  To implement this repo locally, copy the repo to your machine.
  From there open a command line, change your working directory to your copy of the repo, and use ``make build`` or ``docker build .`` to build the container image in the CLI.
  Once the image is built, create a container using ``docker run image``.

  The following sections are an explaination of the contents of repo.

Prereqs
-------

  This repo makes use of UBI8 as the base image for the container derived from `DCAR <https://dcar.dsop.io/>`_.
  If DCAR is unavailable to you, using a `RedHat <https://access.redhat.com/containers/#/registry.access.redhat.com/ubi8/ubi>`_ UBI image is a sufficient substitute.
  NOTE: If substituting the image used, replace ``nexus-docker-secure.levelup-dev.io/redhat/ubi/ubi8:8.1`` in the Dockerfile and Makefile for the image you are utilizing.
  Additionally, this repo makes use of Docker for containers. If you do not wish to use Docker, please make edits to adapt to your implementation of container technology.
  Lastly, you should ensure all files from the repo are present in your local copy.

Makefile
--------

  The Makefile comes with the following commands: help, build, push, build-dep, info.
  ``make help`` will list available commands from the Makefile.
  ``make build`` will build a container image using the Dockerfile in the repo with the tag comprised of the application and version (application:version).
  ``make publish`` will build the container image and then publish the image to Github.
  ``make build-dep`` will generate a tarball containing the dependencies used by the image.
  ``make info`` will list the container registry and repo the image can be published to.
  NOTE: using ``make publish`` provides no benefit by default to those outside of Booz Allen. Additionally, using ``make build-dep`` is unnecessary since the Dockerfile will obtain the needed tarball from Github.

Dockerfile
----------

  This file is setup to generate a container image using ``docker build -t <TAG> .`` with the option to name the image as you wish.
  The build process will consist of using a base image, copying the Booz Allen Public License, applying OpenShift labels, installing required packages and applications, establishing the user the container will run as, and setting a health check.

LICENSE
-------

  This is a text file containing the Booz Allen Public License. Please read before using or distibuting this repo.

Prebuild
--------

  This is a folder containing files and artifacts inherent to the creation of the container image.
  These files and artifacts are used either in the ``make build-dep`` command or in authenticating the dependency tarball associated with the image.
