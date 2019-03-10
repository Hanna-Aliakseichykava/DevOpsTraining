FROM tomcat:8.5-jre8
 

# Download war

ARG REMOTE_NEXUS_URL=''
ARG LOCAL_TOMCAT_APP_URL=http://localhost:8080/app/

ARG WAR_VERSION=0.0.0

RUN \
  apt-get install wget -y && \
  wget ${REMOTE_NEXUS_URL}/content/repositories/snapshots/module7/${WAR_VERSION}/app.war -O ${CATALINA_HOME}/webapps/app.war && \
  rm -r -f ${CATALINA_HOME}/webapps/app/;
