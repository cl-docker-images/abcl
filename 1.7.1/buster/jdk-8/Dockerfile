#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM openjdk:8-jdk-buster

ENV ABCL_VERSION 1.7.1

WORKDIR /usr/local/lib/

ENV ABCL_SIGNING_KEY 5491D207FF9ECDE0BEA277772A9641104DB1773D

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg dirmngr \
    && curl -fL "https://abcl.org/releases/${ABCL_VERSION}/abcl-bin-${ABCL_VERSION}.tar.gz" > "abcl-bin-${ABCL_VERSION}.tar.gz" \
    && curl -fL "https://abcl.org/releases/${ABCL_VERSION}/abcl-bin-${ABCL_VERSION}.tar.gz.asc" > "abcl-bin-${ABCL_VERSION}.tar.gz.asc" \
    && GNUPGHOME="$(mktemp -d)" \
    && export GNUPGHOME \
    && gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "${ABCL_SIGNING_KEY}" \
    && gpg --batch --verify "abcl-bin-${ABCL_VERSION}.tar.gz.asc" "abcl-bin-${ABCL_VERSION}.tar.gz" \
    && gunzip "abcl-bin-${ABCL_VERSION}.tar.gz" \
    && tar xf "abcl-bin-${ABCL_VERSION}.tar" \
    && mv "abcl-bin-${ABCL_VERSION}" abcl \
    && rm -rf "abcl-bin-${ABCL_VERSION}.tar.gz.asc" "abcl-bin-${ABCL_VERSION}.tar" "$GNUPGHOME" \
    && apt-get remove -y curl ca-certificates gnupg dirmngr \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && java -jar /usr/local/lib/abcl/abcl.jar --version

WORKDIR /

COPY abcl-wrapper /usr/local/bin/abcl
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["abcl"]
