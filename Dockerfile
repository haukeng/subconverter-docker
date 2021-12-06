FROM alpine:3.14 AS base

RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata && \
    adduser -D subconverter

FROM alpine:3.14 AS downloader

ARG TARGETPLATFORM
ENV VERSION v0.7.1

WORKDIR /

RUN case ${TARGETPLATFORM} in \
    'linux/amd64') ARCH='linux64' ;; \
    'linux/386') ARCH='linux32' ;; \
    'linux/arm64') ARCH='aarch64' ;; \
    'linux/arm/v7') ARCH='armv7' ;; \
    esac && \
    apk add wget && \
    wget --no-verbose \
    https://github.com/tindy2013/subconverter/releases/download/${VERSION}/subconverter_${ARCH}.tar.gz && \
    tar xzf subconverter_${ARCH}.tar.gz && \ 
    rm -f subconverter_${ARCH}.tar.gz && \
    chmod +x /subconverter/subconverter && \
    cp /subconverter/subconverter /usr/bin/ && \
    rm /subconverter/subconverter && \
    rm /subconverter/*.example.* && \
    rm /subconverter/snippets -rf

FROM base

USER subconverter

WORKDIR /home/subconverter

COPY --from=downloader /usr/bin/subconverter /usr/bin/
COPY --from=downloader --chown=subconverter:subconverter /subconverter .
COPY --chown=subconverter:subconverter config .

EXPOSE 25500

ENTRYPOINT [ "sh", "start.sh" ] 