FROM debian:jessie

MAINTAINER Safia Abdalla <safia@dsfa.io>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y &&\
    apt-get install -y curl git vim wget build-essential python-dev ca-certificates bzip2 libsm6\
        nodejs-legacy npm python-virtualenv python-pip gcc gfortran libglib2.0-0 python-qt4 &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*tmp

RUN useradd -m -s /bin/bash main

EXPOSE 8888

USER main
ENV HOME /home/main
ENV SHELL /bin/bash
ENV USER main
WORKDIR $HOME

ADD handle-requirements.py /home/main/
ADD start-notebook.sh /home/main/
ADD templates/ /srv/templates/


USER root
RUN chmod a+rX /srv/templates
RUN chown -R main:main /home/main

USER main

RUN wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda2-4.0.0-Linux-x86_64.sh
RUN bash Anaconda2-4.0.0-Linux-x86_64.sh -b &&\
    rm Anaconda2-4.0.0-Linux-x86_64.sh
ENV PATH $HOME/anaconda2/bin:$PATH
RUN conda create -n python3 python=3.5 anaconda
RUN /bin/bash -c "source activate python3 && ipython kernel install --user"

RUN /home/main/anaconda2/bin/pip install --upgrade pip

ENV SHELL /bin/bash