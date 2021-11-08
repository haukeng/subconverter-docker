FROM alpine:3.14 AS build

ARG TARGETPLATFORM
ENV VERSION v0.7.1

WORKDIR /

RUN apk add tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

RUN case ${TARGETPLATFORM} in \
    'linux/amd64') ARCH='linux64' ;; \
    'linux/386') ARCH='linux32' ;; \
    'linux/arm64') ARCH='aarch64' ;; \
    'linux/arm/v7') ARCH='armv7' ;; \
    esac \
    && apk add wget \
    && wget --no-verbose https://github.com/tindy2013/subconverter/releases/download/${VERSION}/subconverter_${ARCH}.tar.gz \
    && tar xzf subconverter_${ARCH}.tar.gz \
    && rm -f subconverter_${ARCH}.tar.gz \
    && apk del wget

FROM alpine:3.14

COPY --from=build /etc/localtime /etc/localtime
COPY --from=build /etc/timezone /etc/timezone

COPY --from=build /subconverter/subconverter /usr/bin/

COPY --from=build /subconverter/base /base/base
COPY --from=build /subconverter/config /base/config
COPY --from=build /subconverter/rules /base/rules

COPY config /base

WORKDIR /base

EXPOSE 25500

CMD subconverter