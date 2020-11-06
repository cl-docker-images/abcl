#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM openjdk:11-jdk-buster

ENV ABCL_VERSION 1.8.0

WORKDIR /usr/local/lib/

ARG ABCL_SIGNING_KEY 5491D207FF9ECDE0BEA277772A9641104DB1773D

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg dirmngr \
    && curl -L "https://abcl.org/releases/${ABCL_VERSION}/abcl-bin-${ABCL_VERSION}.tar.gz" > "abcl-bin-${ABCL_VERSION}.tar.gz" \
    && curl -L "https://abcl.org/releases/${ABCL_VERSION}/abcl-bin-${ABCL_VERSION}.tar.gz.asc" > "abcl-bin-${ABCL_VERSION}.tar.gz.asc" \
    && GNUPGHOME="$(mktemp -d)" \
    && export GNUPGHOME \
    && (gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "${ABCL_SIGNING_KEY}" \
       || gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "${ABCL_SIGNING_KEY}" \
       || gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${ABCL_SIGNING_KEY}" \
       || gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "${ABCL_SIGNING_KEY}" \
       || gpg --batch --keyserver pgp.mit.edu --recv-keys "${ABCL_SIGNING_KEY}") \
    && gpg --batch --verify "abcl-bin-${ABCL_VERSION}.tar.gz.asc" "abcl-bin-${ABCL_VERSION}.tar.gz" \
    && gunzip "abcl-bin-${ABCL_VERSION}.tar.gz" \
    && tar xf "abcl-bin-${ABCL_VERSION}.tar" \
    && mv "abcl-bin-${ABCL_VERSION}" abcl \
    && rm -rf "abcl-bin-${ABCL_VERSION}.tar.gz.asc" "abcl-bin-${ABCL_VERSION}.tar" "$GNUPGHOME" \
    && apt-get remove -y curl ca-certificates gnupg dirmngr \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /

COPY abcl-wrapper /usr/local/bin/abcl
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["abcl"]
