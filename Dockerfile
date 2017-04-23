FROM ubuntu:14.04
RUN ./install_build_dependencies.sh

# RUN useradd -ms /bin/bash builder
ENV FIRMWARE_DIR /home/builder/sudowrt-firmware

RUN mkdir -p $FIRMWARE_DIR
RUN mkdir -p $FIRMWARE_DIR/built_firmware
RUN mkdir -p /firmware_images
# RUN chown -HR builder $FIRMWARE_DIR/*

# USER builder
WORKDIR $FIRMWARE_DIR
COPY . $FIRMWARE_DIR

ENTRYPOINT ["./entrypoint.sh"]
