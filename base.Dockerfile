FROM tomcat:8.5-jdk8-openjdk-slim

RUN apt update \
 && apt install -y curl gnupg2 \
 # for backend:
 && echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
 && curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add \
 && apt update \
 && apt install -y sbt \
 && sbt sbtVersion \
 # for frontend:
 && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
 && apt install -y nodejs \
 && npm install -g gulp-cli
