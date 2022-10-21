# OWASP Dependency Check

A container image that Jenkins uses to scan a project's source code to identify components with known vulnerabilities.

## Synopsis

To implement this repo locally:
1. Copy the repo to your machine
2. Open a command line in the directory of your copy of the repo
3. Use `make build` or `docker build .` to build the container image
4. Once the image is built, start a container using `docker run [image-tag]`

## Prerequisites

* [Red Hat Universal Base Image (UBI)](https://catalog.redhat.com/#/registry.access.redhat.com/ubi8/ubi) as the base image for the container
* [Docker](https://www.docker.com/) installed locally (if you do not wish to use Docker, please make edits to adapt to your preferred containerization technology)
* All files from the [owasp-dep-check subdirectory of the SDP-Images repo](https://github.com/boozallen/sdp-images/tree/master/owasp-dep-check)

## Makefile

The Makefile comes with the following commands: `help`, `build`, `push`, and `info`
* `make help` lists available commands from the Makefile
* `make build` builds a container image using the Dockerfile in the repo with the tag comprised of the registry, application, and version (registry/application:version)
* `make publish` builds the container image and then publish the image to GitHub
* `make info` lists the container registry and repo the image will be published to

*note: using `make publish` will require updating the OWNER, REPO, and REGISTRY values in the Makefile*

## Dockerfile

This file is setup to generate a container image using `docker build -t [TAG] .` with the option to name the image as you wish.
The build process consists of:
1. Starting from a base image
2. Copying the Booz Allen Public License
3. Installing required packages and applications
4. Creating and configuring the user the container will run as, and
5. Setting default directory, command, and entrypoint

## LICENSE

This text file contains the Booz Allen Public License. Please read before using or distributing this repo.