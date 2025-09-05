#
# Builder stage - uses base image with all build tools
#
FROM mmisw/orr-base:2025-09-05 AS builder

ARG orrOntVersion

COPY orr-portal /orr-portal
COPY orr-ont /orr-ont

# Build frontend first so it "installs" itself in the backend source:
# Skip PhantomJS since it's not available for ARM64 and only needed for testing
RUN cd /orr-portal/ \
 && npm config set phantomjs_cdnurl "https://github.com/Medium/phantomjs/releases/download/v2.1.1/" \
 && npm install --unsafe-perm=true || npm install --unsafe-perm=true --ignore-scripts \
 && gulp install --base=/ont/ --dest=/orr-ont/src/main/webapp/ \
 # for some reason, cmd above not fully completing, so as a workaround, run it again:
 && gulp install --base=/ont/ --dest=/orr-ont/src/main/webapp/ \
 && test -f /orr-ont/src/main/webapp/index.html

# Build backend to package everything:
RUN cd /orr-ont/ \
 && sbt package

#
# Final runtime stage - clean Tomcat image without build tools
#
FROM tomcat:8.5-jdk8-openjdk-slim

# Copy the built WAR from builder stage
COPY --from=builder /orr-ont/target/scala-2.11/orr-ont_2.11-*.war /usr/local/tomcat/webapps/ont.war

RUN mkdir -p /opt/orr-ont-base-directory
