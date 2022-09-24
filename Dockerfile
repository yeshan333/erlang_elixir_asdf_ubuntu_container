FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y \
    software-properties-common \
    build-essential \
    apt-transport-https \
    unzip \
    tzdata \
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
    libwxgtk3.0-gtk3-dev \
    unixodbc \
    unixodbc-dev \
    m4 \
    default-jdk

RUN locale-gen en_US en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# c++ 17 support
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y  \
    && apt-get update -y \
    && apt-get install gcc-9 g++-9 -y \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9

ENV ADSF_DIR /root/.asdf
ENV PATH $PATH:${ADSF_DIR}/bin:${ADSF_DIR}/shims
ENV ERLANG_VER 23.1.1
ENV ELIXIR_VER v1.10.4
RUN git clone https://github.com/asdf-vm/asdf.git ${ADSF_DIR} --branch v0.5.1 \
    && echo '. ${ADSF_DIR}/asdf.sh' >> ~/.bashrc \
    && echo '. ${ADSF_DIR}/completions/asdf.bash' >> ~/.bashrc
RUN asdf plugin-add erlang https://github.com/yeshan333/asdf-erlang.git \
    && asdf install erlang ${ERLANG_VER}
RUN asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git \
    && asdf install elixir ${ELIXIR_VER}
RUN asdf global erlang ${ERLANG_VER} \
    && asdf global elixir ${ELIXIR_VER} \
    && yes | mix local.hex \
    && yes | mix local.rebar

ENV ERLANG_VER24 24.1
ENV ELIXIR_VER12 1.12.3
RUN asdf install erlang ${ERLANG_VER24} \
    && asdf install elixir ${ELIXIR_VER12}
RUN asdf global erlang ${ERLANG_VER24} \
    && asdf global elixir ${ELIXIR_VER12} \
    && yes | mix local.hex \
    && yes | mix local.rebar

RUN echo 'root:EnjoyLife' | chpasswd