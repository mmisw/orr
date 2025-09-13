#!/bin/bash

# build_all.sh - Complete build script for ORR application.
# This script builds the frontend, backend, and Docker image locally.
# Then, you can push the image to Docker Hub manually.
#
# Usage: ./build_all.sh <version>
#
# Prerequisites:
#   - Java 8 (e.g., via SDKMAN)
#   - Node.js and npm
#   - gulp-cli  (npm install -g gulp-cli)
#   - sbt
#   - Docker

# This script was put together after dealing with lots of issues while
# trying to update the usual dockerfiles for that purpose.
# See https://github.com/mmisw/orr/issues/18.
# With a deployment of mmisw/orr:3.9.84 for http://cor-test.esipfed.org/ont/,
# the resulting container appears to be functional, but it has only been
# tested very minimally.
#

set -eu

# Configuration
ORR_VERSION=$1
JAVA_8_HOME="/Users/carueda/.sdkman/candidates/java/8.0.422-zulu"
IMAGE_NAME="mmisw/orr"
IMAGE_NAME_AND_TAG="$IMAGE_NAME:$ORR_VERSION"
DOCKER_PLATFORM="linux/amd64"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}-->${NC} ${1}"
}

print_success() {
    echo -e "\n${GREEN}--> ✓${NC} ${1}"
}

print_warning() {
    echo -e "${YELLOW}--> ⚠${NC} ${1}"
}

print_error() {
    echo -e "${RED}--> ✗${NC} ${1}"
}

print_step "🚀 Starting ORR build process..."

print_step "Checking prerequisites..."

if [ ! -d "$JAVA_8_HOME" ]; then
    print_error "Java 8 not found at $JAVA_8_HOME"
    print_error "Please install Java 8 via SDKMAN: sdk install java 8.0.422-zulu"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    print_error "npm not found. Please install Node.js"
    exit 1
fi

if ! command -v gulp &> /dev/null; then
    print_error "gulp not found. Installing gulp-cli..."
    npm install -g gulp-cli
fi

if ! command -v docker &> /dev/null; then
    print_error "Docker not found. Please install Docker"
    exit 1
fi

print_success "All prerequisites found"

# Build Frontend
print_step "Building frontend (orr-portal)..."
cd orr-portal

print_step "Installing frontend dependencies..."
npm install --unsafe-perm=true

print_step "Running gulp build to install frontend assets..."
gulp install --base=/ont/ --dest=../orr-ont/src/main/webapp/

# Verify frontend assets were installed
if [ ! -f "../orr-ont/src/main/webapp/index.html" ]; then
    print_error "Frontend build failed - index.html not found"
    exit 1
fi

print_success "Frontend build completed"
cd ..

# Build Backend WAR
print_step "Building backend WAR file (orr-ont)..."
cd orr-ont

# Set Java 8 environment
export JAVA_HOME="$JAVA_8_HOME"
export PATH="$JAVA_HOME/bin:$PATH"

print_step "Using Java version: $(java -version 2>&1 | head -n 1)"
print_step "Running sbt package..."
sbt package

# Verify WAR file was created
WAR_FILE=$(ls target/scala-2.11/orr-ont_2.11-*.war 2>/dev/null || echo "")
if [ -z "$WAR_FILE" ]; then
    print_error "WAR file build failed"
    exit 1
fi

WAR_SIZE=$(ls -lh "$WAR_FILE" | awk '{print $5}')
print_success "Backend WAR built successfully: $WAR_FILE ($WAR_SIZE)"
cd ..

# Build Docker Image
print_step "Building Docker image..."

print_step "Using Docker platform: $DOCKER_PLATFORM"
docker build --platform $DOCKER_PLATFORM -f Dockerfile.runtime-only \
       -t "$IMAGE_NAME_AND_TAG" .

print_success "Docker image built successfully: $IMAGE_NAME_AND_TAG"

# Step 4: Summary
echo
echo "🎉 Build completed successfully!"
echo
echo "Summary:"
echo "  • Frontend assets: ✓ Built and installed"
echo "  • Backend WAR:     ✓ $(ls orr-ont/target/scala-2.11/orr-ont_2.11-*.war | xargs ls -lh | awk '{print $5}')"
echo "  • Docker image:    ✓ $IMAGE_NAME_AND_TAG"
echo
