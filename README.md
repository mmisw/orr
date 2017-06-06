# ORR - Ontology Registry and Repository

The Ontology Registry and Repository (ORR) integrates semantic web services and tools
created by the Marine Metadata Interoperability project, MMI, toward the realization
of its [Semantic Framework](http://marinemetadata.org/semanticframework) vision.
Current funding is provided by the U.S. National Science Foundation through the
[Cross-Domain Observational Metadata for Environmental Sensing (X-DOMES) project](
https://www.earthcube.org/group/x-domes).


For developers, this is a parent repo intended to facilitate the build 
of the integrated backend and frontend components comprising the ORR system.

| component | description |
|-----------|-------------|
| [orr-ont](https://github.com/mmisw/orr-ont)       | Backend / REST endpoint |
| [orr-portal](https://github.com/mmisw/orr-portal) | Front-end |

For end-users, documentation is located at 
[https://mmisw.org/orrdoc/](https://mmisw.org/orrdoc/).

Interested in having an ORR instance on your server? See 
[https://mmisw.org/orrdoc/install/](https://mmisw.org/orrdoc/install/).


## Build 


- `$ git submodule foreach "(git checkout master; git pull)"`
- `$ git submodule update`
- Check submodule versions and determine version for integrated system 
- `$ ./build.sh 3.6.2`


This builds the complete ORR system: 
- WAR `orr-ont/target/scala-2.11/orr-ont_2.11-3.x.y.war`
- Docker image: `mmisw/orr:3.x.y`
