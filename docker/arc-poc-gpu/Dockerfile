FROM nvidia/cuda:11.2.2-runtime-ubuntu20.04

LABEL maintainer "Intelygenz - Konstellation Team"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# github actions needs a non-root to run
RUN useradd -m ga && chown -R ga /home/ga

WORKDIR /home/ga/actions-runner

# install Docker for some Github Actions to run
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
      ca-certificates \
      curlapt-transport-https \
      gcc \
      git \
      python3-dev \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" && \
    apt-get update && \
    apt-cache policy docker-ce && \
    apt-get install -y docker-ce
RUN usermod -aG docker ga

# Install Github Actions runner
RUN curl -s -O -L https://github.com/actions/runner/releases/download/v2.277.1/actions-runner-linux-x64-2.277.1.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.277.1.tar.gz && \
    ./bin/installdependencies.sh

USER ga

RUN curl -s -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    echo '. ~/miniconda3/etc/profile.d/conda.sh' >> ~/.bashrc
