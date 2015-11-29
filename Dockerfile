FROM quay.io/goodguide/base:ubuntu-15.10-0

RUN apt-get update \
 && apt-get install \
    gnupg \
    iptables \
    libgpgme11 \
    libgpgme11-dev \

 # initialize GPG
 && gpg --refresh-keys

ENV CONFD_VERSION='0.10.0' \
    FWKNOP_VERSION='2.6.7' \
    PREFIX=/usr

RUN curl -fsSL -o /usr/bin/confd "https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64" \
 && chmod +x /usr/bin/confd

COPY gpg/signing_key /tmp/fwknop_signing_key
RUN set -x \
 && cd /tmp \
 && gpg --import fwknop_signing_key \
 && curl -fsSLO "http://www.cipherdyne.org/fwknop/download/fwknop-${FWKNOP_VERSION}.tar.gz" \
 && curl -fsSLO "http://www.cipherdyne.org/fwknop/download/fwknop-${FWKNOP_VERSION}.tar.gz.asc" \
 && gpg --verify "fwknop-${FWKNOP_VERSION}.tar.gz.asc" \
 && mkdir -p fwknop \
 && tar -xvzf "fwknop-${FWKNOP_VERSION}.tar.gz" --strip-components=1 -C ./fwknop/ \
 && cd ./fwknop/ \
 && apt-get install \
      file \
      gcc \
      make \
 && ./configure \
      --prefix="$PREFIX" \
      --sysconfdir=/etc \
      --disable-dependency-tracking \
      --disable-client \
      --enable-udp-server \
      --with-gpgme \
 && make \
 && make install \
 && cd /tmp \
 && apt-get remove --auto-remove --purge \
      file \
      gcc \
      make \
 && apt-get clean \
 && rm -rf /tmp/*

COPY confd/ /etc/confd/
COPY entrypoint.sh /usr/bin/start_fwknopd

# This isn't really useful, as we'll need to run this container with net=host, but it's nice to explicitly state the ports we'll be using:
EXPOSE 62201/udp

ENV GNUPGHOME "~/.gnupg"
VOLUME ["/root/.gnupg", "/usr/var/fwknop"]
ENTRYPOINT ["/usr/bin/start_fwknopd"]
