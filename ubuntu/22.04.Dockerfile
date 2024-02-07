FROM ubuntu:22.04

RUN apt-get update -y && apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive TZ=Asia/Shanghai apt-get install -y \
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
    libwxgtk3.0-gtk3-dev \
    unixodbc \
    unixodbc-dev \
    m4 \
    default-jdk \
    tzdata \
    net-tools

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
ENV ERLANG_VER 24.1
ENV ELIXIR_VER 1.12.3
RUN git clone https://github.com/asdf-vm/asdf.git ${ADSF_DIR} --branch v0.14.0 \
    && echo '. ${ADSF_DIR}/asdf.sh' >> /root/.bashrc \
    && echo '. ${ADSF_DIR}/completions/asdf.bash' >> /root/.bashrc
RUN asdf plugin-add erlang https://github.com/yeshan333/asdf-erlang.git \
    && asdf install erlang ${ERLANG_VER}
RUN asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git \
    && asdf install elixir ${ELIXIR_VER}
RUN asdf global erlang ${ERLANG_VER} \
    && asdf global elixir ${ELIXIR_VER} \
    && yes | mix local.hex \
    && yes | mix local.rebar

ENV ERLANG_VER26 26.2.1
ENV ELIXIR_VER16 1.16.1
RUN asdf install erlang ${ERLANG_VER26} \
    && asdf install elixir ${ELIXIR_VER16}
RUN asdf global erlang ${ERLANG_VER26} \
    && asdf global elixir ${ELIXIR_VER16} \
    && yes | mix local.hex \
    && yes | mix local.rebar

# beautify terminal
RUN wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh \
    && chmod +x /usr/local/bin/oh-my-posh
RUN mkdir /root/.poshthemes \
    && wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O /root/.poshthemes/themes.zip \
    && unzip /root/.poshthemes/themes.zip -d /root/.poshthemes \
    && chmod u+rw /root/.poshthemes/*.omp.* \
    && rm /root/.poshthemes/themes.zip
RUN echo 'eval "$(oh-my-posh init bash --config /root/.poshthemes/lambdageneration.omp.json)"' >> /root/.bashrc

# Remember install fonts
# oh-my-posh font install
RUN echo 'root:EnjoyLife' | chpasswd