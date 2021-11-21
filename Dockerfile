FROM ubuntu:16.04

RUN apt-get update && apt-get upgrade

RUN apt-get install -y \
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
    libwxgtk3.0-dev \
    unixodbc \
    unixodbc-dev \
    openjdk-8-jdk=8u292-b10-0ubuntu1~16.04.1

RUN locale-gen en_US en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# set timezone
RUN echo "Asia/shanghai" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV CLASSPATH .:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
ENV PATH $PATH:${JAVA_HOME}/bin

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