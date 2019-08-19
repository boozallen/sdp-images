.. home: 

--------------------
SDP Container Images
--------------------

==========================
Building the Documentation
==========================

The documentation is built using `Sphinx <http://www.sphinx-doc.org/en/master/>`_ and the 
`Read the Docs <https://sphinx-rtd-theme.readthedocs.io/en/stable/>`_ theme. 

The documentation is configured via the ``conf.py`` file at the root of this repository. 

Building the documentation requires docker and can be done via: 

    | ``make docs`` 

This will compile the documentation and can be viewed at ``docs/_build/html/README.html``. 

*************
Hot Reloading
*************

To get view the documentation updated in realtime during local development, run: 

    | ``make docs live``

The documentation will be viewable at ``http://localhost:8000``

.. toctree::
   :caption: Images 🐳

   jenkins/README
   jenkins-agent/README
   sonarqube/README