# FDS base image
FROM openbcl/fds:6.9.0

# install app dependencies
RUN apt-get update && apt-get install -y git libmpich-dev python3-pip python3.10-venv

# create python venv for propti
RUN python3 -m venv /opt/venv/propti

# append python venv for propti to path
ENV PATH="/opt/venv/propti/bin:$PATH"

# install python dependencies
RUN pip install matplotlib mpi4py numpy pandas scipy spotpy

# install propti
RUN git clone https://github.com/FireDynamics/propti.git /root/propti/ && \
    sed -i '1 i\#!/usr/bin/env python3\n' /root/propti/*.py && \
    echo '/usr/bin/env bash -l -c "$*"' > /root/propti/wrap.sh && \
    chmod +x /root/propti/wrap.sh && \
    chmod +x /root/propti/*.py && \
    ln -s /root/propti/wrap.sh /bin/wrap && \
    ln -s /root/propti/propti_analyse.py /bin/propti_analyse && \
    ln -s /root/propti/propti_prepare.py /bin/propti_prepare && \
    ln -s /root/propti/propti_run.py /bin/propti_run && \
    ln -s /root/propti/propti_sense.py /bin/propti_sense