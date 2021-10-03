#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM openjdk:8-jdk-bullseye

# Install the packages that buildpack-deps adds on top of
# buildpack-deps:scm. This is a bit odd for a JVM based image, but the CFFI
# project is commonly used and requires a compiler, headers, etc. Additionally,
# this gives a more uniform experience between the different cl-docker-images
# project's images.
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        bzip2 \
        default-libmysqlclient-dev \
        dpkg-dev \
        file \
        g++ \
        gcc \
        imagemagick \
        libbz2-dev \
        libc6-dev \
        libcurl4-openssl-dev \
        libdb-dev \
        libevent-dev \
        libffi-dev \
        libgdbm-dev \
        libglib2.0-dev \
        libgmp-dev \
        libjpeg-dev \
        libkrb5-dev \
        liblzma-dev \
        libmagickcore-dev \
        libmagickwand-dev \
        libmaxminddb-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libpng-dev \
        libpq-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libtool \
        libwebp-dev \
        libxml2-dev \
        libxslt-dev \
        libyaml-dev \
        make \
        patch \
        unzip \
        xz-utils \
        zlib1g-dev \
        \
    ; \
    rm -rf /var/lib/apt/lists/*

# Install Maven as it is commonly used with ABCL, including with anything that
# uses CFFI. We install it ourselves instead of basing the image off of maven
# because the maven image only follows openjdk's default OS choice and does not
# provide Debian based images for jdk12+.

ARG MAVEN_VERSION=3.8.3
ARG MAVEN_SHA=b0bf39460348b2d8eae1c861ced6c3e8a077b6e761fb3d4669be5de09490521a74db294cf031b0775b2dfcd57bd82246e42ce10904063ef8e3806222e686f222

WORKDIR /usr/share/maven

RUN curl -fsSL https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz > /tmp/apache-maven.tar.gz \
  && echo "${MAVEN_SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

# Now install ABCL

ENV ABCL_VERSION 1.8.0

WORKDIR /usr/local/share/

ENV ABCL_SIGNING_KEY 5491D207FF9ECDE0BEA277772A9641104DB1773D

RUN set -x \
    && curl -fsSL "https://abcl.org/releases/${ABCL_VERSION}/abcl-bin-${ABCL_VERSION}.tar.gz" > "abcl-bin-${ABCL_VERSION}.tar.gz" \
    && curl -fsSL "https://abcl.org/releases/${ABCL_VERSION}/abcl-bin-${ABCL_VERSION}.tar.gz.asc" > "abcl-bin-${ABCL_VERSION}.tar.gz.asc" \
    && curl -fsSL "https://abcl.org/releases/${ABCL_VERSION}/abcl-src-${ABCL_VERSION}.tar.gz" > "abcl-src-${ABCL_VERSION}.tar.gz" \
    && curl -fsSL "https://abcl.org/releases/${ABCL_VERSION}/abcl-src-${ABCL_VERSION}.tar.gz.asc" > "abcl-src-${ABCL_VERSION}.tar.gz.asc" \
    && GNUPGHOME="$(mktemp -d)" \
    && export GNUPGHOME \
    && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${ABCL_SIGNING_KEY}" \
    && gpg --batch --verify "abcl-bin-${ABCL_VERSION}.tar.gz.asc" "abcl-bin-${ABCL_VERSION}.tar.gz" \
    && gpg --batch --verify "abcl-src-${ABCL_VERSION}.tar.gz.asc" "abcl-src-${ABCL_VERSION}.tar.gz" \
    && gunzip "abcl-bin-${ABCL_VERSION}.tar.gz" \
    && tar xf "abcl-bin-${ABCL_VERSION}.tar" \
    && gunzip "abcl-src-${ABCL_VERSION}.tar.gz" \
    && tar xf "abcl-src-${ABCL_VERSION}.tar" \
    && mv "abcl-bin-${ABCL_VERSION}" abcl \
    && mkdir -p /usr/local/src \
    && mv "abcl-src-${ABCL_VERSION}" /usr/local/src/abcl/ \
    && rm -rf "abcl-bin-${ABCL_VERSION}.tar.gz.asc" "abcl-bin-${ABCL_VERSION}.tar" "abcl-src-${ABCL_VERSION}.tar.gz.asc" "abcl-src-${ABCL_VERSION}.tar" "$GNUPGHOME" \
    && java -jar /usr/local/share/abcl/abcl.jar --batch --eval '(print (multiple-value-list (lisp-implementation-version)))'

# Add the Quicklisp installer.
WORKDIR /usr/local/share/common-lisp/source/quicklisp/

ENV QUICKLISP_SIGNING_KEY D7A3489DDEFE32B7D0E7CC61307965AB028B5FF7

RUN set -x \
    && curl -fsSL "https://beta.quicklisp.org/quicklisp.lisp" > quicklisp.lisp \
    && curl -fsSL "https://beta.quicklisp.org/quicklisp.lisp.asc" > quicklisp.lisp.asc \
    && GNUPGHOME="$(mktemp -d)" \
    && export GNUPGHOME \
    && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${QUICKLISP_SIGNING_KEY}" \
    && gpg --batch --verify "quicklisp.lisp.asc" "quicklisp.lisp" \
    && rm quicklisp.lisp.asc \
    && rm -rf "$GNUPGHOME"

# Add the script to trivially install Quicklisp
COPY install-quicklisp /usr/local/bin/install-quicklisp

# Install cl-launch. In the next release, move this up so that all images can
# share it.
# hadolint ignore=DL3008
RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends -y cl-launch \
    && rm -rf /var/lib/apt/lists/*

# Add the entrypoint
WORKDIR /

COPY abcl-wrapper /usr/local/bin/abcl
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["abcl"]
