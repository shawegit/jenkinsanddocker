FROM ubuntu

RUN apt-get update
RUN apt-get install -y build-essential wget cmake software-properties-common checkinstall
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
RUN apt-get update
RUN apt-get install gcc-snapshot -y
RUN apt-get update
RUN apt-get install gcc-6 g++-6 -y 
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
# This is all stuff required for tests and nicely displayed testresults
RUN apt-get install -y libboost-test-dev python python-pip xsltproc cppcheck
RUN pip install gcovr

RUN useradd jenkins --shell /bin/bash --create-home
USER jenkins






