# FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
FROM nvidia/cuda@sha256:1d36277d7f886815b2548cc457e3d510006c0252359e9b28c92ed617f28edd72
#checkov:skip=CKV_DOCKER_2: "Ensure that HEALTHCHECK instructions have been added to container images"

# OCI Labels will be added using GitHub Actions
LABEL maintainer "Intelygenz - Konstellation Team"

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

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

WORKDIR /tmp

RUN \
    rm -rf /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/nvidia-ml.list && \
    # ==================================================================
    # Create NB_USER user and group
    # ------------------------------------------------------------------
    groupadd -g "${NB_GID}" "${NB_USER}" && \
    useradd -l -m -s /bin/bash -N -g "${NB_GID}" -u "${NB_UID}" "${NB_USER}" && \
    # ==================================================================
    # OS dependencies
    # ------------------------------------------------------------------
    # Update cuda keyring
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub && \
    # Install dependencies
    apt-get update && apt-get install -y --no-install-recommends -qq \
      apt-utils=2.4.9 \
      build-essential=12.9ubuntu3 \
      ca-certificates=20211016ubuntu0.22.04.1 \
      cmake=3.22.1-1ubuntu1.22.04.1 \
      curl=7.81.0-1ubuntu1.10 \
      gnupg2=2.2.27-3ubuntu2.1 \
      gpg-agent=2.2.27-3ubuntu2.1 \
      libaio1=0.3.112-13build1 \
      libffi-dev=3.4.2-4 \
      libgl1-mesa-glx=22.2.5-0ubuntu0.1~22.04.3 \
      libllvm-15-ocaml-dev=1:15.0.7-0ubuntu0.22.04.1 \
      libltdl7=2.4.6-15build2 \
      libsm6=2:1.2.3-1build2 \
      libssl-dev=3.0.2-0ubuntu1.10 \
      libxext-dev=2:1.3.4-1build1 \
      libxrender1=1:0.9.10-1build4 \
      llvm-15=1:15.0.7-0ubuntu0.22.04.1 \
      llvm-15-dev=1:15.0.7-0ubuntu0.22.04.1 \
      llvm-15-runtime=1:15.0.7-0ubuntu0.22.04.1 \
      llvm-15-tools=1:15.0.7-0ubuntu0.22.04.1 \
      locales=2.35-0ubuntu3.1 \
      lsb-release=11.1.0ubuntu4 \
      netcat=1.218-4ubuntu1 \
      openssh-client=1:8.9p1-3ubuntu0.1 \
      python3-dev=3.10.6-1~22.04 \
      python3-distutils-extra=2.45 \
      python3-distutils=3.10.6-1~22.04 \
      python3-pip=22.0.2+dfsg-1ubuntu0.3 \
      python3=3.10.6-1~22.04 \
      software-properties-common=0.99.22.7 \
      tzdata=2023c-0ubuntu0.22.04.2 \
      unzip=6.0-26ubuntu3.1 \
      wget=1.21.2-2ubuntu1 \
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
    apt-get update && apt-get install -y --no-install-recommends -qq nodejs=16.20.1-deb-1nodesource1 && \
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
    setuptools==67.2.0 \
    wheel==0.38.4 \
    && \
    python -m pip --no-cache-dir install --upgrade --ignore-installed \
    pycrypto==2.6.1 \
    future==0.18.3 \
    notebook==6.5.2 \
    jupyterhub==3.1.1 \
    jupyterlab==3.6.1 \
    pipenv==2023.2.4

# # ==================================================================
# # Install tools
# # ------------------------------------------------------------------
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

# # ==================================================================
# # config & cleanup
# # ------------------------------------------------------------------
RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*

# # ==================================================================
# # Command
# # ------------------------------------------------------------------
WORKDIR /home/${NB_USER}

USER ${NB_USER}

CMD ["bash"]
