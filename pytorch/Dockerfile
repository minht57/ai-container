# Build: docker build -f Dockerfile -t aimc-pytorch:0.5 .

ARG BASE=ai-base
ARG VERSION=0.5-vnc-vs
ARG BASE_CONTAINER=$BASE:$VERSION
FROM $BASE_CONTAINER

LABEL maintainer="Tri Phan <triphan.vnvl@gmail.com>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Switch back to jovyan to avoid accidental container runs as root
USER ${NB_UID}

WORKDIR "${HOME}"

# Install Pytorch with pip
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
