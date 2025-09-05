FROM tomcat:8.5-jdk8-openjdk-slim

RUN apt update \
 && apt install -y curl gnupg2 \
 # for backend:
 && echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee -a /etc/apt/sources.list.d/sbt.list \
 && echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
 && curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add \
 && apt update \
 && apt install -y sbt \
 # for frontend:
 && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
 && apt install -y nodejs npm \
 && npm install -g gulp-cli
