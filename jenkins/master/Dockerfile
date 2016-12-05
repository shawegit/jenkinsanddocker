FROM jenkins:latest
MAINTAINER GeneralInterfaces

USER root

RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins

RUN apt-get update 
# Install docker 
RUN apt-get install -y apt-transport-https ca-certificates
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" | tee /etc/apt/sources.list.d/docker.list
RUN apt-get update 
RUN apt-get install -y docker-engine wget zip

# Need to give sudo writes to jenkins user
RUN apt-get install -y sudo
RUN rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-5.6.zip && unzip sonarqube-5.6 && mv sonarqube-5.6 /opt/sonar
RUN wget https://github.com/SonarOpenCommunity/sonar-cxx/releases/download/cxx-0.9.6/sonar-cxx-plugin-0.9.6.jar && mv sonar-cxx-plugin-0.9.6.jar /opt/sonar/extensions/plugins

RUN wget http://sourceforge.net/projects/pmd/files/pmd/4.2.6/pmd-bin-4.2.6.zip && unzip pmd-bin-4.2.6 && mv pmd-bin-4.2.6 /opt/pmd

USER jenkins
ENV JAVA_OPTS="-Xmx8192m"
ENV JENKINS_OPTS="--logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war"

# Here some hacky stuff to run docker without typing sudo docker ...
USER root
COPY run.sh ./run.sh 
RUN chmod 755 ./run.sh
ENTRYPOINT ["/bin/bash","-c","./run.sh"]