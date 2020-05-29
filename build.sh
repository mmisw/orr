#!/bin/bash

function usage() {
	echo "Usage:"
	echo "  ./build.sh <version> [ <orrOntVersion> ]"
	echo
	echo "<version>       Desired version for the ORR image"
	echo "<orrOntVersion> Version of orr-ont component"
	echo
	echo "Example:    (but see README)"
	echo "  ./build.sh ${ORR_VERSION} ${BACKEND_VERSION}"
	echo
	exit
}

version=$1

if [ "$version" == "" ]; then
	usage
fi
orrOntVersion=$2
if [ "$orrOntVersion" == "" ]; then
	orrOntVersion=${version}
fi

set -e
set -u

function main {
    echo "building $version  (orrOntVersion=${orrOntVersion})"
    echo "building image mmisw/orr:$version"
    docker build --build-arg orrOntVersion=${orrOntVersion} \
           -t "mmisw/orr:$version" .
}

main
