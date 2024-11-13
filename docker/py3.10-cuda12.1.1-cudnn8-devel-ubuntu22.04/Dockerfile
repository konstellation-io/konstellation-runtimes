# FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04
FROM nvidia/cuda@sha256:21196d81f56b48dbee70494d5f10322e1a77cc47ffe202a3bf68eab81533c20f
#checkov:skip=CKV_DOCKER_2: "Ensure that HEALTHCHECK instructions have been added to container images"

# OCI Labels will be added using GitHub Actions
LABEL maintainer="Intelygenz - Konstellation Team"

# Set build arguments
ARG NB_USER="coder"
ARG NB_UID="1000"
ARG NB_GID="1000"
ARG PROTOC_VERSION=3.19.4
ARG KST_CLI_VERSION=2.1.0
ARG MINIO_CLIENT_VERSION=mc.RELEASE.2023-01-28T20-29-38Z
ARG CML_VERSION=0.18.21
ARG GOLANG_VERSION=1.20.1
ARG DEBIAN_FRONTEND=noninteractive

ENV LANG=C.UTF-8
ENV PATH=/home/${NB_USER}/.local/bin:/usr/local/go/bin:$PATH
ENV PIPENV_VENV_IN_PROJECT=1
ENV CUDA_DRIVER=550
ENV CUDA_DRIVER_PACKAGE_VERSION=550.54.15

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Switch to root and /tmp to do administrative tasks
USER root
WORKDIR /tmp

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends -qq cuda-drivers-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-1 \
        nvidia-driver-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        libnvidia-gl-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        nvidia-dkms-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        nvidia-kernel-common-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        nvidia-kernel-source-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        libnvidia-compute-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        libnvidia-extra-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        nvidia-compute-utils-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        libnvidia-decode-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        libnvidia-encode-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        nvidia-utils-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        xserver-xorg-video-nvidia-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        libnvidia-cfg1-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 \
        libnvidia-fbc1-${CUDA_DRIVER}=${CUDA_DRIVER_PACKAGE_VERSION}-0ubuntu1 && \
    rm -f /etc/apt/sources.list.d/cuda-ubuntu2204-x86_64.list && apt-get clean && \
    # ==================================================================
    # Create NB_USER user and group
    # ------------------------------------------------------------------
    groupadd -g "${NB_GID}" "${NB_USER}" && \
    useradd -l -m -s /bin/bash -N -g "${NB_GID}" -u "${NB_UID}" "${NB_USER}" && \
   # Adding support for nvidia drivers ${CUDA_DRIVER}
    ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.1 /usr/local/cuda-12.1/compat/libcuda.so.1 && \
    ln -sf /usr/lib/x86_64-linux-gnu/libcudadebugger.so.1 /usr/local/cuda-12.1/compat/libcudadebugger.so.1 && \
    ln -sf /usr/lib/x86_64-linux-gnu/libnvidia-ptxjitcompiler.so.1 /usr/local/cuda-12.1/compat/libnvidia-ptxjitcompiler.so.1 && \
    ln -sf /usr/lib/x86_64-linux-gnu/libnvidia-nvvm.so.4 /usr/local/cuda-12.1/compat/libnvidia-nvvm.so.4 && \
    # ==================================================================
    # OS dependencies
    # ------------------------------------------------------------------
    # Update cuda keyring
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub && \
    # Install dependencies
    # hadolint ignore=DL3008
    apt-get update && apt-get install -y --no-install-recommends -qq \
      apt-utils \
      build-essential \
      ca-certificates \
      cmake \
      curl \
      ffmpeg \
      freeglut3-dev \
      gnupg2 \
      gpg-agent \
      libaio1 \
      libffi-dev \
      libgl1-mesa-glx \
      libgles2-mesa-dev \
      libglfw3-dev \
      libllvm-15-ocaml-dev \
      libltdl7 \
      libsm6 \
      libssl-dev \
      libxext-dev \
      libxrender1 \
      llvm-15 \
      llvm-15-dev \
      llvm-15-runtime \
      llvm-15-tools \
      locales \
      lsb-release \
      netcat \
      openssh-client \
      python3-dev \
      python3-distutils-extra \
      python3-distutils \
      python3-pip \
      python3 \
      software-properties-common \
      tzdata \
      unzip \
      wget \
    && \
    # ==================================================================
    # Set locale
    # ------------------------------------------------------------------
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    # ==================================================================
    # git
    # ------------------------------------------------------------------
    add-apt-repository --yes --no-update ppa:git-core/ppa && \
    # hadolint ignore=DL3008
    apt-get update &&  apt-get install -y --no-install-recommends -qq \
    git && \
    # ==================================================================
    # Set Python3.10 as default
    # ------------------------------------------------------------------
    update-alternatives --install /usr/local/bin/python python /usr/bin/python3.10 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    update-alternatives --install /usr/bin/python3-config python3-config /usr/bin/python3.10-config 1 && \
    # ==================================================================
    # nodejs
    # ------------------------------------------------------------------
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee /usr/share/keyrings/nodesource.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x $(lsb_release -s -c) main" |tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x $(lsb_release -s -c) main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y --no-install-recommends -qq nodejs=16.20.2-deb-1nodesource1 && \
    # ==================================================================
    # golang
    # ------------------------------------------------------------------
    curl -fsSL -O https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    echo "000a5b1fca4f75895f78befeb2eecf10bfff3c428597f3f1e69133b63b911b02 go${GOLANG_VERSION}.linux-amd64.tar.gz" | sha256sum -c && \
    tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    # ==================================================================
    # clean up
    # ------------------------------------------------------------------
    apt-get clean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nodesource.list

# ==================================================================
# python libraries
# ------------------------------------------------------------------
RUN python -m pip --no-cache-dir install --upgrade \
    pip==23.0.1 \
    setuptools==75.5.0 \
    wheel==0.38.4 && \
    python -m pip --no-cache-dir install --upgrade --ignore-installed \
    pycrypto==2.6.1 \
    future==0.18.3 \
    notebook==6.5.2 \
    jupyterhub==3.1.1 \
    jupyterlab==3.6.1 \
    pipenv==2023.2.4

# ==================================================================
# Install tools
# ------------------------------------------------------------------
RUN \
    # protoc compiler
    curl -sLO "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip" && \
    unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip && \
    mv bin/protoc /usr/local/bin/protoc && \
    chmod +x /usr/local/bin/protoc && \
    # konstellation KLI
    curl -sLO "https://github.com/konstellation-io/kli/releases/download/v${KST_CLI_VERSION}/kli_${KST_CLI_VERSION}_linux_amd64.tar.gz" && \
    curl -sL "https://github.com/konstellation-io/kli/releases/download/v${KST_CLI_VERSION}/kli_${KST_CLI_VERSION}_checksums.txt" | sha256sum --check --ignore-missing --quiet || exit 1 && \
    tar xzf kli_${KST_CLI_VERSION}_linux_amd64.tar.gz -C /usr/local/bin --strip-components=2 kli_${KST_CLI_VERSION}_linux_amd64/bin/kli && \
    # minio client
    curl -sL "https://dl.min.io/client/mc/release/linux-amd64/archive/${MINIO_CLIENT_VERSION}" -O && \
    curl -s https://dl.min.io/client/mc/release/linux-amd64/archive/${MINIO_CLIENT_VERSION}.sha256sum | sha256sum -c && \
    mv ${MINIO_CLIENT_VERSION} /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc && \
    # cml
    curl -sL -o /usr/local/bin/cml "https://github.com/iterative/cml/releases/download/v${CML_VERSION}/cml-linux-x64" && \
    chmod +x /usr/local/bin/cml

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
WORKDIR /home/${NB_USER}

USER ${NB_USER}

CMD ["bash"]
