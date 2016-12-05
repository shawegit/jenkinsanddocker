FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y build-essential wget cmake software-properties-common

# Add new gcc and g++
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y && apt-get update
RUN apt-get install gcc-snapshot -y && apt-get update
RUN apt-get install gcc-6 g++-6 -y 
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5

# This is all stuff required for tests and nicely displayed testresults
RUN apt-get install -y libboost-test-dev python python-pip xsltproc cppcheck valgrind
RUN pip install gcovr

RUN useradd jenkins --shell /bin/bash --create-home

# Give user jenkins sudo rights.
RUN apt-get update  && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins






