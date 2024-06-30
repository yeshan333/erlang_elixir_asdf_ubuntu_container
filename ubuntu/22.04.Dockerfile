FROM ubuntu:22.04

RUN DEBIAN_FRONTEND=noninteractive TZ=Asia/Shanghai apt-get update -y && apt-get upgrade -y \ 
    && apt-get install -y \
        software-properties-common \
        build-essential \
        apt-transport-https \
        unzip \
        sudo \
        locales \
        iputils-ping \
        git \
        curl \
        wget \
        sysstat \
        libssl-dev \
        make \
        automake \
        autoconf \
        libncurses5-dev \
        gcc \
        xsltproc \
        fop \
        libxml2-utils \
        libwxgtk3.2-gtk3-dev \
        libwxgtk-webview3.2-gtk3-dev \
        unixodbc \
        unixodbc-dev \
        m4 \
        default-jdk \
        tzdata \
        net-tools \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV ADSF_DIR /root/.asdf
ENV PATH $PATH:${ADSF_DIR}/bin:${ADSF_DIR}/shims
ENV ERLANG_VER 26.2.1
ENV ELIXIR_VER 1.16.1
ENV KERL_BUILD_DOCS yes
ENV MAKEFLAGS -j4

RUN git clone https://github.com/asdf-vm/asdf.git ${ADSF_DIR} --branch v0.14.0 \
    && echo '. ${ADSF_DIR}/asdf.sh' >> /root/.bashrc \
    && echo '. ${ADSF_DIR}/completions/asdf.bash' >> /root/.bashrc
RUN asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git \
    && asdf install erlang ${ERLANG_VER}
RUN asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git \
    && asdf install elixir ${ELIXIR_VER}
RUN asdf global erlang ${ERLANG_VER} \
    && asdf global elixir ${ELIXIR_VER} \
    && yes | mix local.hex \
    && yes | mix local.rebar
