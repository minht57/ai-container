# Build: docker build -f vnc.Dockerfile -t ai-base:0.5-vnc-vs .

FROM ai-base:0.5

USER root

RUN apt-get -y -q update \
    && apt-get -y -q install \
    dbus-x11 \
    xorg \
    firefox \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xubuntu-icon-theme \
    curl \
    iputils-ping \
    build-essential \
    make \
    cmake \
    g++ \
    clang \
    git \
    htop \
    libopencv-dev \
    # chown $HOME to workaround that the xorg installation creates a
    # /home/jovyan/.cache directory owned by root
    && chown -R $NB_UID:$NB_GID $HOME \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade nvitop

# Installation de Code Server et server-proxy/vscode-proxy pour intégrer Code dans JupyterLab
ENV CODE_VERSION=4.16.1
RUN curl -fOL https://github.com/coder/code-server/releases/download/v$CODE_VERSION/code-server_${CODE_VERSION}_amd64.deb \
    && dpkg -i code-server_${CODE_VERSION}_amd64.deb \
    && rm -f code-server_${CODE_VERSION}_amd64.deb
RUN /opt/conda/bin/conda install -c conda-forge jupyter-server-proxy
RUN /opt/conda/bin/conda install -c conda-forge jupyter-vscode-proxy

# Install TurboVNC (https://github.com/TurboVNC/turbovnc)
ARG TURBOVNC_VERSION=2.2.6
RUN wget -q "https://sourceforge.net/projects/turbovnc/files/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb/download" -O turbovnc.deb \
    && apt-get install -y -q ./turbovnc.deb \
    # remove light-locker to prevent screen lock
    && apt-get remove -y -q light-locker \
    && rm ./turbovnc.deb \
    && ln -s /opt/TurboVNC/bin/* /usr/local/bin/ \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rm -rf /tmp/* && chmod -R 777 /tmp/

COPY jupyter_remote_desktop_proxy /opt/install/jupyter_remote_desktop_proxy
COPY setup.py MANIFEST.in README.md LICENSE /opt/install/
RUN fix-permissions /opt/install

USER $NB_USER
RUN cd /opt/install \
    && mamba install -y websockify \
    && pip install --no-cache-dir -e . && \
    mamba clean --all
