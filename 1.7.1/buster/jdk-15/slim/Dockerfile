#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM openjdk:15-jdk-slim-buster

ENV ABCL_VERSION 1.7.1

WORKDIR /usr/local/share/

ENV ABCL_SIGNING_KEY 5491D207FF9ECDE0BEA277772A9641104DB1773D

RUN set -x \
    # Install fetch deps
    && apt-get update \
    && apt-get install --no-install-recommends -y curl gnupg dirmngr \
    && curl -fsSL "https://abcl.org/releases/${ABCL_VERSION}/abcl-bin-${ABCL_VERSION}.tar.gz" > "abcl-bin-${ABCL_VERSION}.tar.gz" \
    && curl -fsSL "https://abcl.org/releases/${ABCL_VERSION}/abcl-bin-${ABCL_VERSION}.tar.gz.asc" > "abcl-bin-${ABCL_VERSION}.tar.gz.asc" \
    && GNUPGHOME="$(mktemp -d)" \
    && export GNUPGHOME \
    && gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "${ABCL_SIGNING_KEY}" \
    && gpg --batch --verify "abcl-bin-${ABCL_VERSION}.tar.gz.asc" "abcl-bin-${ABCL_VERSION}.tar.gz" \
    && gunzip "abcl-bin-${ABCL_VERSION}.tar.gz" \
    && tar xf "abcl-bin-${ABCL_VERSION}.tar" \
    && mv "abcl-bin-${ABCL_VERSION}" abcl \
    && rm -rf "abcl-bin-${ABCL_VERSION}.tar.gz.asc" "abcl-bin-${ABCL_VERSION}.tar" "$GNUPGHOME" \
    # Remove fetch deps
    && apt-get remove -y curl gnupg dirmngr \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    # Smoke test ABCL.
    && java -jar /usr/local/share/abcl/abcl.jar --batch --eval '(print (multiple-value-list (lisp-implementation-version)))'

WORKDIR /

COPY abcl-wrapper /usr/local/bin/abcl
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["abcl"]
