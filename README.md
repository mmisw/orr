# ORR - Ontology Registry and Repository

The Ontology Registry and Repository (ORR) integrates semantic web services and tools
created by the Marine Metadata Interoperability project, MMI, toward the realization
of its [Semantic Framework](https://marinemetadata.org/semanticframework) vision.
Current funding is provided by the U.S. National Science Foundation through the
[Cross-Domain Observational Metadata for Environmental Sensing (X-DOMES) project](
https://www.earthcube.org/group/x-domes).

For end-users, documentation is located at 
[https://mmisw.org/orrdoc/](https://mmisw.org/orrdoc/).

----

For developers, this is a parent repo that facilitates the build of the 
integrated ORR system comprising its backend and frontend components,
which are referenced via git submodules:

| component | description |
|-----------|-------------|
| [https://github.com/mmisw/orr-ont](https://github.com/mmisw/orr-ont)       | Backend |
| [https://github.com/mmisw/orr-portal](https://github.com/mmisw/orr-portal) | Frontend |

Actual code development occurs within those repos.

## Build 

Two deployable ORR artifacts are built in this repo: WAR and Docker image.
The steps are:

- `$ git submodule foreach "(git checkout master; git pull)"`
- Check submodule versions and determine version for integrated system
  (as an example, `3.x.y` in what follows).
- `$ ./build.sh 3.x.y`

This creates: 
- WAR:          `orr-ont/target/scala-2.11/orr-ont_2.11-3.x.y.war`
- Docker image: `mmisw/orr:3.x.y`

Publishing the Docker image:
- `docker login`
- `docker push mmisw/orr:3.x.y`

Finally:
- `git add -u`
- `git commit -m "update orr-portal and orr-ont pointers and build v.3.x.y"`
