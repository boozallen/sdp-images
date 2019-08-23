.. home: 

--------------------
SDP Container Images
--------------------

==================
Listing the Images
==================

Run ``make list`` to see all of the images built by this repository 
and the base directory where you can find their resources. 

=================
Building an Image
=================

Within the images directory, run ``make build`` to build the image. 

================
Pushing an Image
================

Within the images directory, run ``make push`` to build and push the image. 

You will be prompted for your GitHub Username and Password.

You must have ``read:packages`` and ``write:packages`` permissions to push to 
the github container registry

=================
Versioning Images
=================

Each ``Makefile`` has a ``VERSION`` variable at the top which contains the 
tag that will be used when building and pushing the container image.  

When making changes, the Pull Request should include an incremented container 
image version change. 

==========================
Building the Documentation
==========================

The documentation is built using `Sphinx <http://www.sphinx-doc.org/en/master/>`_ and the 
`Read the Docs <https://sphinx-rtd-theme.readthedocs.io/en/stable/>`_ theme. 

The documentation is configured via the ``conf.py`` file at the root of this repository. 

Building the documentation requires docker and can be done via: 

    | ``make html`` 

This will compile the documentation and can be viewed at ``docs/index.html``. 

*************
Hot Reloading
*************

To get view the documentation updated in realtime during local development, run: 

    | ``make html live``

The documentation will be viewable at ``http://localhost:8000/readme.html``

.. toctree::
   :caption: Images 🐳

   jenkins/README
   jenkins-agent/README
   sonarqube/README