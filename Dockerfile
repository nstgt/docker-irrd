FROM debian:stretch-slim

ENV IRRD_VERSION 3.0.8

WORKDIR /root

RUN apt-get update && apt-get install -y \
    git \
    wget \
    byacc \
    automake \
    autoconf \
    build-essential \
    gnupg \
    flex \
    libglib2.0-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/irrdnet/irrd/archive/v$IRRD_VERSION.tar.gz \
 && tar zxvf v$IRRD_VERSION.tar.gz \
 && cd irrd-$IRRD_VERSION/src \
 && ./autogen.sh \
 && ./configure \
 && make \
 && make install

RUN mkdir -p /var/spool/irr_database

ADD setup.sh /root/setup.sh
RUN chmod +x /root/setup.sh

CMD /root/setup.sh
