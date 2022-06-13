FROM nvidia/cuda:11.6.1-cudnn8-devel-ubuntu18.04
LABEL maintainer "Intelygenz - Konstellation Team"
ARG NB_USER="coder"
ARG NB_UID="1000"
ARG NB_GID="1000"
ARG VERSION=2.5.0
ARG PIP_TARGET_FOLDER=/kernel/lib/python/site-packages
ARG APT_INSTALL="apt-get install -y --no-install-recommends"
ARG PIP_INSTALL="python -m pip --no-cache-dir install --upgrade"
ARG PROTOC_VERSION=3.19.4
ARG KST_CLI_VERSION=1.0-alpha.4
ENV LANG=C.UTF-8
ENV KERNEL_LANGUAGE=python
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER root
RUN apt-get update && \
    # ==================================================================
    # Create NB_USER user and group
    # ------------------------------------------------------------------
    groupadd -g "${NB_GID}" "${NB_USER}" && \
    useradd -l -m -s /bin/bash -N -g "${NB_GID}" -u "${NB_UID}" "${NB_USER}" && \
    # ==================================================================
    # tools
    # ------------------------------------------------------------------
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
    build-essential \
    apt-utils \
    ca-certificates \
    wget \
    git \
    libssl-dev \
    curl \
    libaio1 \
    libffi-dev \
    libgl1-mesa-glx \
    libsm6 \
    libltdl7 \
    libllvm-10-ocaml-dev \
    llvm-10 \
    llvm-10-dev \
    llvm-10-runtime \
    llvm-10-tools \
    libxext-dev \
    libxrender1 \
    netcat \
    openssh-client \
    python3-dev \
    software-properties-common \
    tzdata \
    unzip \
    cmake \
    locales \
    && \
    # ==================================================================
    # Set locale
    # ------------------------------------------------------------------    
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    # ==================================================================
    # Python
    # ------------------------------------------------------------------
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
    python3.9 \
    python3.9-dev \
    python3.9-distutils \
    python3-distutils-extra \
    && \
    curl -o ~/get-pip.py \
    https://bootstrap.pypa.io/get-pip.py && \
    python3.9 ~/get-pip.py && \
    ln -s /usr/bin/python3.9 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.9 /usr/local/bin/python
# ==================================================================
# python libraries
# ------------------------------------------------------------------
RUN $PIP_INSTALL \
    setuptools \
    wheel \
    && \
    $PIP_INSTALL \
    pycrypto \
    future \
    notebook \
    jupyterhub \
    jupyterlab \
    pipenv \
    && \
    # ==================================================================
    # Enterprise gateway kernel bootstrap & cleanup
    # ------------------------------------------------------------------
    curl -L https://github.com/jupyter/enterprise_gateway/releases/download/v${VERSION}/jupyter_enterprise_gateway_kernel_image_files-${VERSION}.tar.gz | \
    tar -xz -C /usr/local/bin && \
    chown ${NB_USER}:${NB_USER} /usr/local/bin/bootstrap-kernel.sh && \
    chmod 0755 /usr/local/bin/bootstrap-kernel.sh && \
    chown -R ${NB_USER}:${NB_USER} /usr/local/bin/kernel-launchers && \
    # ==================================================================
    # make PYTHONPATH folder for Jupyter kernels
    # ------------------------------------------------------------------
    mkdir -p ${PIP_TARGET_FOLDER} && \
    chown -R ${NB_USER}:${NB_USER} ${PIP_TARGET_FOLDER}
# ==================================================================
# Install tools
# ------------------------------------------------------------------    
RUN \
    # protoc compiler
    curl -o protoc.zip -LO "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip" && \
    unzip -o protoc.zip -d /usr/local bin/protoc && \
    chmod +x /usr/local/bin/protoc && \
    rm -f protoc.zip && \
    # konstellation KLI
    curl -o kli.tar.gz -LO "https://github.com/konstellation-io/kli/releases/download/v${KST_CLI_VERSION}/kli_${KST_CLI_VERSION}_linux_amd64.tar.gz" && \
    tar xvf kli.tar.gz && \
    mv kli_${KST_CLI_VERSION}_linux_amd64/bin/kli /usr/local/bin && \
    rm -f kli.tar.gz
# ==================================================================
# config & cleanup
# ------------------------------------------------------------------
RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*
# ==================================================================
# Command
# ------------------------------------------------------------------
USER ${NB_USER}
ENV PATH=/home/${NB_USER}/.local/bin:$PATH
ENV PIPENV_VENV_IN_PROJECT=1
CMD ["/usr/local/bin/bootstrap-kernel.sh"]
