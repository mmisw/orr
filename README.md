[![](https://img.shields.io/docker/cloud/build/mmisw/orr)](https://hub.docker.com/r/mmisw/orr)
[![](https://img.shields.io/docker/cloud/automated/mmisw/orr)](https://hub.docker.com/r/mmisw/orr)

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

## Clone

For a fresh clone of this repo on your system, you can run the following
to fetch everything including submodules:

```
git clone --recursive https://github.com/mmisw/orr.git
```

If you have already cloned this repo but forgot the `--recursive` flag,
then run:

```
git submodule update --init --recursive
```

## Build

### Base image

```
docker build -f base.Dockerfile -t "mmisw/orr-base:2020-09-12" .

docker push "mmisw/orr-base:2020-09-12"
```

## ORR image

The main deployable ORR artifact that is built in this repo is the
[mmisw/orr docker image](https://hub.docker.com/r/mmisw/orr).

The typical sequence of steps to build a new ORR version reflecting
latest submodule changes is as follows:

```
git submodule foreach "(git checkout master; git pull)"
```

Check the submodule versions to determine the version for the integrated system,
for example, `3.x.y`.  Typically this is going to be the version of the
orr-portal module (see `version` entry in [orr-portal/package.json](orr-portal/package.json))
as this is the one displayed to the end user in the frontend.

We assume such version for the integrated ORR system is captured in the
`ORR_VERSION` environment variable in what follows.

```
ORR_VERSION=3.x.y
```

The `./build.sh` script that we will be running in a moment takes care of
building the whole system. This script expects one or two arguments.
The first argument is the version for the ORR integrated system.
So, we will use `${ORR_VERSION}` for this.
The second argument is only required if the version of the backend
component (see `build.Version` entry in [orr-ont/project/build.scala](orr-ont/project/build.scala))
is different:

```
BACKEND_VERSION=3.w.z
```

Then, run `./build.sh` accordingly, that is, either:

```
./build.sh ${ORR_VERSION}
```

or:

```
./build.sh ${ORR_VERSION} ${BACKEND_VERSION}
```

**NOTE**: This may take several minutes to complete.

Example of complete output
[here](https://gist.github.com/carueda/980020ffa0662a11a3a129b8a1274a2f).

Publishing the Docker image:

```
docker login
docker push mmisw/orr:${ORR_VERSION}
```

Finally:

```
git add -u
git commit -m "build v${ORR_VERSION}"
git push origin master
git tag "v${ORR_VERSION}"
git push origin "v${ORR_VERSION}"
```
