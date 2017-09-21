#!/bin/bash

function usage() {
	echo "Usage:"
	echo "  ./build.sh <version>"
	echo
	echo "For the moment, try to indicate a version that aligns with those of the components."
	echo
	echo "Example:"
	echo "  ./build.sh 3.6.5"
	echo
	exit
}

version=$1

if [ "$version" == "" ]; then
	usage
fi

set -e
set -u

function main {
    package_orr_portal
    package_orr_ont
    dockerize
}

function package_orr_portal {
    # that is, "install" orr-portal under orr-ont's webapp dir
    cd orr-portal
    npm install
    gulp install --base=/ont/ --dest=../orr-ont/src/main/webapp/
    cd ..
}

function package_orr_ont {
    cd orr-ont
    sbt8 test package
    cd ..
}

function dockerize {
    docker build --build-arg version=${version} -t "mmisw/orr:$version" --no-cache .
}

main