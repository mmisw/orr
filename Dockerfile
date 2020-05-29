FROM mmisw/orr-base:2020-05-29

COPY orr-portal /orr-portal
COPY orr-ont /orr-ont

ARG orrOntVersion

# frontend first so it "installs" itself in the backend source:
RUN cd /orr-portal/ \
 && npm install \
 && gulp install --base=/ont/ --dest=/orr-ont/src/main/webapp/ \
 # for some reason, cmd above not fully completing, so as a workaround, run it again:
 && gulp install --base=/ont/ --dest=/orr-ont/src/main/webapp/ \
 && test -f /orr-ont/src/main/webapp/index.html \
# then backend to package everything:
 && cd /orr-ont/ \
 && sbt package \
 && mv target/scala-2.11/orr-ont_2.11-${orrOntVersion}.war /usr/local/tomcat/webapps/ont.war

RUN mkdir -p /opt/orr-ont-base-directory
