FROM alpine:edge AS builder
MAINTAINER Xueshan Feng <xueshan.feng@gmail.com>

ENV VERSION 0.7.0

RUN apk --update add \
   bash \
   curl \
   git \
   g++ \
   make \
   openssh \
   openssl \
   openssl-dev \
   && rm -rf /var/cache/apk/*

RUN curl -L https://github.com/AGWA/git-crypt/archive/$VERSION.tar.gz | tar zxv -C /var/tmp
RUN cd /var/tmp/git-crypt-$VERSION && CXXFLAGS='-DOPENSSL_API_COMPAT=0x30000000L' make && make install PREFIX=/usr/local

FROM alpine:edge

RUN apk --no-cache --update add \
   bash \
   curl \
   diffutils \
   git \
   jq \
   libstdc++ \
   openssh \
   openssl \
   && mkdir -p /usr/local/bin \
   && rm -rf /var/cache/apk/*

COPY --from=builder /usr/local/bin/git-crypt /usr/local/bin/git-crypt

WORKDIR /git
VOLUME /git
ENTRYPOINT ["git"]
CMD ["--help"]
