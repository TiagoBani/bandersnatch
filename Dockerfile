FROM alpine:3.12 AS gpac_builder

WORKDIR /app

RUN apk update && \
    apk add --no-cache \
        wget \
        g++ \
        make \
        && \
    wget --no-check-certificate https://codeload.github.com/gpac/gpac/zip/master -O gpac-master.zip && \
    unzip gpac-master.zip

WORKDIR gpac-master

RUN ./configure --use-zlib=no && \
    make && \
    mkdir -p install/bin && \
    cp -R ./bin/gcc ./install/lib && \
    rm ./install/lib/gm_* ./install/lib/*.a && \
    rm -Rf ./install/lib/temp && \
    mv ./install/lib/MP4* ./install/bin


FROM node:14.15-alpine3.12

RUN apk update && \
    apk add --no-cache \
        ffmpeg

WORKDIR /app

COPY --from=gpac_builder /app/gpac-master/install/lib /usr/lib
COPY --from=gpac_builder /app/gpac-master/install/bin /usr/bin

CMD [ "./script.sh" ]
