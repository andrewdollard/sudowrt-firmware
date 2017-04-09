FROM ubuntu:14.04
RUN apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -yq \
      git-core \
      libssl-dev \
      build-essential=11.6ubuntu6 \
      subversion=1.8.8-1ubuntu3.2 \
      libncurses5-dev=5.9+20140118-1ubuntu1 \
      zlib1g-dev=1:1.2.8.dfsg-1ubuntu1 \
      gawk=1:4.0.1+dfsg-2.1ubuntu2 \
      gcc-multilib=4:4.8.2-1ubuntu6 \
      flex=2.5.35-10.1ubuntu2 \
      gettext=0.18.3.1-1ubuntu3 \
      quilt=0.61-1 \
      ccache=3.1.9-1 \
      xsltproc=1.1.28-2build1 \
      unzip=6.0-9ubuntu1.5 \
      python=2.7.5-5ubuntu3 \
      wget=1.15-1ubuntu1.14.04.2
RUN apt-get clean

RUN useradd -ms /bin/bash builder
ENV FIRMWARE_DIR /home/builder/sudowrt-firmware

RUN mkdir -p $FIRMWARE_DIR
RUN mkdir -p /firmware_images

WORKDIR $FIRMWARE_DIR
COPY . $FIRMWARE_DIR
RUN chown -hR builder $FIRMWARE_DIR/*
USER builder
ENTRYPOINT ["./entrypoint.sh"]
