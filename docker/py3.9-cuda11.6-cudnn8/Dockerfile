# FROM nvidia/cuda:11.6.1-cudnn8-runtime-ubuntu18.04
FROM nvidia/cuda@sha256:5613daec96132bb370d64f6422f57bbcec96df0011d0d61f46da9d8a973a1855
#checkov:skip=CKV_DOCKER_2: "Ensure that HEALTHCHECK instructions have been added to container images"

# OCI Labels will be added using GitHub Actions
LABEL maintainer "Intelygenz - Konstellation Team"

ARG NB_USER="coder"
ARG NB_UID="1000"
ARG NB_GID="1000"
ARG PROTOC_VERSION=3.19.4
ARG KST_CLI_VERSION=1.0-alpha.4
ARG MINIO_CLIENT_VERSION=mc.RELEASE.2023-01-28T20-29-38Z
ARG CML_VERSION=0.18.21
ARG DEBIAN_FRONTEND=noninteractive

ENV LANG=C.UTF-8
ENV PATH=/home/${NB_USER}/.local/bin:$PATH
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
    apt-get update && apt-get install -y --no-install-recommends -qq \
      apt-utils=1.6.14 \
      build-essential=12.4ubuntu1 \
      ca-certificates=20211016ubuntu0.18.04.1 \
      cmake=3.10.2-1ubuntu2.18.04.2 \
      curl=7.58.0-2ubuntu3.22 \
      libaio1=0.3.110-5ubuntu0.1 \
      gnupg=2.2.4-1ubuntu1.6 \
      libffi-dev=3.2.1-8 \
      libgl1-mesa-glx=20.0.8-0ubuntu1~18.04.1 \
      libllvm-10-ocaml-dev=1:10.0.0-4ubuntu1~18.04.2 \
      libltdl7=2.4.6-2 \
      libsm6=2:1.2.2-1 \
      libssl-dev=1.1.1-1ubuntu2.1~18.04.21 \
      libxext-dev=2:1.3.3-1 \
      libxrender1=1:0.9.10-1 \
      llvm-10=1:10.0.0-4ubuntu1~18.04.2 \
      llvm-10-dev=1:10.0.0-4ubuntu1~18.04.2 \
      llvm-10-runtime=1:10.0.0-4ubuntu1~18.04.2 \
      llvm-10-tools=1:10.0.0-4ubuntu1~18.04.2 \
      locales=2.27-3ubuntu1.6 \
      lsb-release=9.20170808ubuntu1 \
      netcat=1.10-41.1 \
      openssh-client=1:7.6p1-4ubuntu0.7 \
      python3-dev=3.6.7-1~18.04 \
      software-properties-common=0.96.24.32.20 \
      tzdata=2022g-0ubuntu0.18.04 \
      unzip=6.0-21ubuntu1.2 \
      wget=1.19.4-1ubuntu2.2 \
    && \
    # ==================================================================
    # Set locale
    # ------------------------------------------------------------------
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    # ==================================================================
    # python, git
    # ------------------------------------------------------------------
    add-apt-repository --yes --no-update ppa:deadsnakes/ppa && \
    add-apt-repository --yes --no-update ppa:git-core/ppa && \
    apt-get update &&  apt-get install -y --no-install-recommends -qq \
    git=1:2.39.2-0ppa1~ubuntu18.04.1 \
    python3.9=3.9.16-1+bionic1 \
    python3.9-dev=3.9.16-1+bionic1 \
    python3.9-distutils=3.9.16-1+bionic1 \
    python3-distutils-extra=2.41ubuntu1 \
    python3-pip=9.0.1-2.3~ubuntu1.18.04.6 && \
    # ==================================================================
    # Set Python3.9 as default
    # ------------------------------------------------------------------
    update-alternatives --install /usr/local/bin/python python /usr/bin/python3.9 1 && \
    # ==================================================================
    # nodejs
    # ------------------------------------------------------------------
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee /usr/share/keyrings/nodesource.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x $(lsb_release -s -c) main" |tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x $(lsb_release -s -c) main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y --no-install-recommends -qq nodejs=16.19.1-deb-1nodesource1 && \
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
