#!/bin/bash

function usage() {
	echo "Usage:"
	echo "  ./build.sh <version> [ <orrOntVersion> ]"
	echo
	echo "<version>       Desired version for the ORR image"
	echo "<orrOntVersion> Version of orr-ont component"
	echo
	echo "Example:"
	echo "  ./build.sh 3.7.2 3.7.0"
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
    package_orr_portal
    package_orr_ont
    dockerize
}

function package_orr_portal {
    echo "packaging orr-portal"
    # that is, "install" orr-portal under orr-ont's webapp dir
    cd orr-portal
    npm install
    gulp install --base=/ont/ --dest=../orr-ont/src/main/webapp/
    cd ..
}

function package_orr_ont {
    echo "packaging orr-ont"
    cd orr-ont
    sbt test package
    cd ..
}

function dockerize {
    echo "building image mmisw/orr:$version"
    docker build --build-arg orrOntVersion=${orrOntVersion} \
           -t "mmisw/orr:$version" --no-cache .
}

main
