# Deployment

## Docker-based deployment

This is the recommended mechanism. Please see the instructions at 
https://mmisw.org/orrdoc/install/.

## Standard deployment

You will need the following services:
 
- [MongoDB](https://www.mongodb.com/)
- [AllegroGraph](http://franz.com/agraph/allegrograph/)
- [Apache Tomcat](http://tomcat.apache.org/)

Get the latest WAR from the releases at https://github.com/mmisw/orr/releases,
follow the instruction regarding configuration of your ORR instance
as described for the docker based mechanism,
and deploy the WAR file under your Tomcat service. 
