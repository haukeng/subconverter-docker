FROM alpine:3.8
LABEL maintainer="Haukeng"

ENV VERSION v0.6.3

WORKDIR /base
RUN apk add wget tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    wget -P /base https://github.com/tindy2013/subconverter/releases/download/${VERSION}/subconverter_linux64.tar.gz && \
    tar xzf subconverter_linux64.tar.gz && \
    rm -rf subconverter_linux64.tar.gz && \
    sed -i '/TW/s/🇨🇳/🇹🇼/g' /base/subconverter/snippets/emoji.txt && \
    apk del wget tzdata

COPY groups.txt /base/subconverter/snippets

EXPOSE 25500

CMD ./subconverter/subconverter
