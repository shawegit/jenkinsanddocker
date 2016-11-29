FROM ubuntu

RUN apt-get update
RUN apt-get install -y build-essential wget cmake 

RUN useradd jenkins --shell /bin/bash --create-home
USER jenkins
