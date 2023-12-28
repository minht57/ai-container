# Build: docker build -f Dockerfile -t aimc-tf2:0.5 .

ARG BASE=ai-base
ARG VERSION=0.5-vnc-vs
ARG BASE_CONTAINER=$BASE:$VERSION
FROM $BASE_CONTAINER

LABEL maintainer="Tri Phan <triphan.vnvl@gmail.com>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Install all OS dependencies for Server that starts
# but lacks all features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --yes && \
    # - apt-get upgrade is run to patch known vulnerabilities in apt-get packages as
    #   the ubuntu base image is rebuilt too seldom sometimes (less than once a month)
    apt-get upgrade --yes && \
    apt-get install --yes --no-install-recommends \
    tensorrt && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Switch back to jovyan to avoid accidental container runs as root
USER ${NB_UID}

WORKDIR "${HOME}"

RUN conda install \
      -c conda-forge cudatoolkit=11.8.0 && \
    python3 -m pip install nvidia-cudnn-cu11==8.6.0.163 tensorflow==2.12.* && \
    conda clean --all