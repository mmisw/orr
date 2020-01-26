#
# builder
#
# (using jdk8 duw to some sbt error during building with jdk11)
FROM tomcat:8.5.45-jdk8-openjdk-slim AS builder

RUN apt update \
 && apt install -y curl gnupg2 \
 # backend
 && echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
 && curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add \
 && apt update \
 && apt install -y sbt \
 && sbt sbtVersion \
 # frontend
 && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
 && apt install -y nodejs \
 && npm install -g gulp

COPY orr-portal /orr-portal
COPY orr-ont /orr-ont

# frontend first so it "installs" itself in backend source:
RUN cd /orr-portal/ \
 && npm install \
 && gulp install --base=/ont/ --dest=/orr-ont/src/main/webapp/

# then backend to package everything:
RUN cd /orr-ont/ \
 && sbt package

#
# final image:
#
FROM tomcat:8.5.45-jdk11-openjdk-slim

COPY --from=builder /orr-ont/target/scala-2.11/orr-ont_*.war /usr/local/tomcat/webapps/ont.war

RUN mkdir -p /opt/orr-ont-base-directory
