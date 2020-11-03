FROM openjdk:8-buster

LABEL maintainer="etimmons@mit.edu"

ENV ABCL_VERSION=1.8.0

WORKDIR /usr/local/src/

ARG ABCL_SIGNING_KEY=5491D207FF9ECDE0BEA277772A9641104DB1773D

# hadolint ignore=DL3003,DL3008
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg dirmngr ant \
    && curl -L https://abcl.org/releases/${ABCL_VERSION}/abcl-src-${ABCL_VERSION}.tar.gz > abcl-src-${ABCL_VERSION}.tar.gz \
    && curl -L https://abcl.org/releases/${ABCL_VERSION}/abcl-src-${ABCL_VERSION}.tar.gz.asc > abcl-src-${ABCL_VERSION}.tar.gz.asc \
    && GNUPGHOME="$(mktemp -d)" \
    && export GNUPGHOME \
    && (gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys ${ABCL_SIGNING_KEY} \
       || gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys ${ABCL_SIGNING_KEY} \
       || gpg --batch --keyserver keyserver.ubuntu.com --recv-keys ${ABCL_SIGNING_KEY} \
       || gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ${ABCL_SIGNING_KEY} \
       || gpg --batch --keyserver pgp.mit.edu --recv-keys ${ABCL_SIGNING_KEY}) \
    && gpg --batch --verify "abcl-src-${ABCL_VERSION}.tar.gz.asc" "abcl-src-${ABCL_VERSION}.tar.gz" \
    && gunzip "abcl-src-${ABCL_VERSION}.tar.gz" \
    && tar xf "abcl-src-${ABCL_VERSION}.tar" \
    && ( cd "abcl-src-${ABCL_VERSION}" && bash ./ci/create-abcl-properties.bash "openjdk8" && ant abcl ) \
    && ln -s "/usr/local/src/abcl-src-$ABCL_VERSION/abcl" /usr/local/bin/abcl \
    && rm -rf "abcl-src-${ABCL_VERSION}.tar.gz.asc" "abcl-src-${ABCL_VERSION}.tar" "$GNUPGHOME" \
    && apt-get remove -y curl ca-certificates gnupg dirmngr ant \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /

COPY docker-entrypoint /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

CMD ["abcl"]
