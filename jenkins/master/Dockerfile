FROM jenkins:latest
MAINTAINER Simon Hawe sh@gi.ai

USER root

RUN mkdir /var/log/jenkins && chown -R jenkins:jenkins /var/log/jenkins
RUN mkdir /var/cache/jenkins && chown -R jenkins:jenkins /var/cache/jenkins

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

USER jenkins
ENV JAVA_OPTS="-Xmx8192m"
ENV JENKINS_OPTS="--logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war"
# Install plugins that are not default plugins
#COPY plugins.txt /plugins.txt
# Max be this works under linux, under windows it did not and I had to manually add each plugin inside this dockerfile
#RUN /usr/local/bin/install-plugins.sh /plugins.txt
RUN /usr/local/bin/install-plugins.sh \
  greenballs \
  docker-workflow \
  sonar \
  blueocean \
  bitbucket \
  disk-usage
# Here some hacky stuff to run docker without typing sudo docker ...
USER root
COPY run.sh ./run.sh 
RUN chmod 755 ./run.sh
ENTRYPOINT ["/bin/bash","-c","./run.sh"]