[![](https://images.microbadger.com/badges/version/mmisw/orr.svg)](https://microbadger.com/images/mmisw/orr "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/mmisw/orr.svg)](https://microbadger.com/images/mmisw/orr "Get your own image badge on microbadger.com")

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

**NOTE**: A MongoDB server must be running locally (on port 27017)
for the tests done during the orr-ont build below.
(You can take a look at the [travis spec](https://github.com/mmisw/orr-ont/blob/master/.travis.yml)
and the [builds at Travis](https://travis-ci.org/mmisw/orr-ont).)

Two deployable ORR artifacts are built in this repo:
[WAR](https://github.com/mmisw/orr/releases)
and
[Docker image](https://cloud.docker.com/u/mmisw/repository/docker/mmisw/orr).

The typical sequence of steps to build a new ORR version reflecting
latest submodule changes is as follows:

```
git submodule foreach "(git checkout master; git pull)"
```

Check the submodule versions and determine the version for the integrated system,
for example, `3.x.y`.  Typically this is going to be the version of the
orr-portal module as this is the one displayed to the end user in the frontend.

We assume the version for the integrated ORR system to be captured in
`ORR_VERSION` in what follows.

```
ORR_VERSION=3.x.y
```

The `./build.sh` script that we will be running in a moment takes care of
building the whole system. This script expects one or two arguments.
The first argument is the version for the ORR integrated system.
So, we will use `${ORR_VERSION}` for this.
The second argument is only required if the version of the backend
component (orr-ont) is different:

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

Example of complete output
[here](https://gist.github.com/carueda/980020ffa0662a11a3a129b8a1274a2f).

This creates:
- WAR:          `orr-ont/target/scala-2.11/orr-ont_2.11-${BACKEND_VERSION}.war`
- Docker image: `mmisw/orr:${ORR_VERSION}`

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

If a new backend system has been built according to `${BACKEND_VERSION}`
as described above, then create a corresponding release at
https://github.com/mmisw/orr/releases with the WAR file.

# Versions

- ORR docker image 3.8.5:
    - orr-portal 3.8.3
    - orr-ont 3.8.3
