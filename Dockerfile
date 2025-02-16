# syntax = docker/dockerfile:1.2

FROM nvidia/cuda:12.6.0-cudnn-runtime-ubuntu22.04
SHELL ["/bin/bash", "-c"] 
WORKDIR /root

ENV LANG C.UTF-8
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    nano \
    curl \
    wget \
    git \
    git-lfs \
    gcc

RUN add-apt-repository -y ppa:deadsnakes/ppa && apt-get install -y \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3-distutils-extra

RUN ln -s /usr/bin/python3.11 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.11 /usr/local/bin/python

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3
ENV PATH=$PATH:/root/.local/bin
ENV PIP_ROOT_USER_ACTION=ignore

# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_network
# https://developer.nvidia.com/cudnn-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_network
# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
# RUN dpkg -i cuda-keyring_1.1-1_all.deb

# RUN apt-get update && apt-get install -y \
#     cuda-toolkit-12-6 \
#     cudnn

ENV PATH=$PATH:/usr/local/cuda/bin
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

RUN python3 -m pip --no-cache-dir install --upgrade \
    jupyterlab \
    jupyterlab-git \
    ipykernel \
    ipywidgets \
    matplotlib

COPY run.sh .
RUN chmod +x run.sh

EXPOSE 8888 6006

CMD ["/root/run.sh"]