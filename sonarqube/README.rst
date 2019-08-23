---------
SonarQube
---------

extends `sonarqube:6.7 <https://hub.docker.com/_/sonarqube/>`_ image and adds some 
environment variable configurations. 


.. csv-table:: Environment Variables
   :header: "Name", "Description", "Default" 

    "WEB_CONTEXT", "the root path to access sonarqube, for when hosting behind an ALB with path based routing.", "" 