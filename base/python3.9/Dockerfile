FROM ubuntu:18.04
LABEL maintainer "Intelygenz - Konstellation Team"
ARG NB_USER="coder"
ARG NB_UID="1000"
ARG NB_GID="1000"
ARG VERSION=2.5.0
ARG PIP_TARGET_FOLDER=/kernel/lib/python/site-packages
ENV LANG=C.UTF-8
ENV KERNEL_LANGUAGE=python
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER root
RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get update && \
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
        libsm6 \
        libltdl7 \
        libxext-dev \
        libxrender1 \
        netcat \
        openssh-client \
        python3-dev \
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
# python
# ------------------------------------------------------------------
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        software-properties-common \
        && \
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
    ln -s /usr/bin/python3.9 /usr/local/bin/python && \
    $PIP_INSTALL \
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
# config & cleanup
# ------------------------------------------------------------------
    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/* && \
# ==================================================================
# make PTHONPATH folder for Jupyter kernels
# ------------------------------------------------------------------
    mkdir -p ${PIP_TARGET_FOLDER} && \
    chown -R ${NB_USER}:${NB_USER} ${PIP_TARGET_FOLDER}

# ==================================================================
# Command
# ------------------------------------------------------------------
USER ${NB_USER}
ENV PATH=/home/${NB_USER}/.local/bin:$PATH
ENV PIPENV_VENV_IN_PROJECT=1
CMD ["/usr/local/bin/bootstrap-kernel.sh"]
