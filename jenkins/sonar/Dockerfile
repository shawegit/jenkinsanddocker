FROM openjdk:8-jdk
MAINTAINER Simon Hawe sh@gi.ai

ENV SONAR_VERSION=5.6.3 \
	SONAR_CXX_VERSION=0.9.6\
    SONARQUBE_HOME=/opt/sonarqube \
    # Database configuration
    # Defaults to using H2
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

RUN apt-get update && apt-get install wget zip -y
RUN wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip && unzip sonarqube-$SONAR_VERSION && mv sonarqube-$SONAR_VERSION $SONARQUBE_HOME && rm sonarqube-$SONAR_VERSION.zip*

RUN wget https://github.com/SonarOpenCommunity/sonar-cxx/releases/download/cxx-$SONAR_CXX_VERSION/sonar-cxx-plugin-$SONAR_CXX_VERSION.jar && mv sonar-cxx-plugin-$SONAR_CXX_VERSION.jar $SONARQUBE_HOME/extensions/plugins

VOLUME ["$SONARQUBE_HOME/data", "$SONARQUBE_HOME/extensions"]

USER root
COPY run.sh ./run.sh 
RUN chmod 755 ./run.sh
ENTRYPOINT ["/bin/bash","-c","./run.sh"]