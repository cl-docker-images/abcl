#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM openjdk:11-jdk-buster

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
# provide buster based images for jdk12+.

ARG MAVEN_VERSION=3.6.3
ARG MAVEN_SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0

WORKDIR /usr/share/maven

RUN curl -fsSL https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz > /tmp/apache-maven.tar.gz \
  && echo "${MAVEN_SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

# Now install ABCL

ENV ABCL_COMMIT c49c756bb94129ddbf47b6f5d56cc9bd08e4cc5b

WORKDIR /usr/local/src/

RUN set -x \
    # Install ant
    && ANT_VERSION="1.10.9" \
    && curl -fsSL "https://mirrors.gigenet.com/apache/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz" > "ant-$ANT_VERSION.tar.gz" \
    && tar xf "ant-$ANT_VERSION.tar.gz" \
    && PATH="/usr/local/src/apache-ant-$ANT_VERSION/bin:$PATH" \
    && ANT_HOME="/usr/local/src/apache-ant-$ANT_VERSION" \
    && export ANT_HOME \
    # Install ABCL
    && curl -fsSL "https://github.com/armedbear/abcl/archive/$ABCL_COMMIT.tar.gz" > "abcl-$ABCL_COMMIT.tar.gz" \
    && tar xf "abcl-$ABCL_COMMIT.tar.gz" \
    && JAVA_MAJOR_VERSION="${JAVA_VERSION%%.*}" \
    && JAVA_MAJOR_VERSION="${JAVA_MAJOR_VERSION%%u*}" \
    && export JAVA_MAJOR_VERSION \
    && mkdir /usr/local/share/abcl/ \
    && mv "abcl-$ABCL_COMMIT" abcl \
    && (cd "abcl" && bash ./ci/create-abcl-properties.bash "openjdk$JAVA_MAJOR_VERSION" && ant && cp dist/* /usr/local/share/abcl && ant clean ) \
    && rm -rf "abcl-$ABCL_COMMIT.tar.gz" ant* apache-ant* \
    && java -jar /usr/local/share/abcl/abcl.jar --eval '(print (multiple-value-list (lisp-implementation-version)))' --eval '(quit)'

# Add the Quicklisp installer.
WORKDIR /usr/local/share/common-lisp/source/quicklisp/

ENV QUICKLISP_SIGNING_KEY D7A3489DDEFE32B7D0E7CC61307965AB028B5FF7

RUN set -x \
    && curl -fsSL "https://beta.quicklisp.org/quicklisp.lisp" > quicklisp.lisp \
    && curl -fsSL "https://beta.quicklisp.org/quicklisp.lisp.asc" > quicklisp.lisp.asc \
    && GNUPGHOME="$(mktemp -d)" \
    && export GNUPGHOME \
    && gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "${QUICKLISP_SIGNING_KEY}" \
    && gpg --batch --verify "quicklisp.lisp.asc" "quicklisp.lisp" \
    && rm quicklisp.lisp.asc \
    && rm -rf "$GNUPGHOME"

# Add the entrypoint
WORKDIR /

COPY abcl-wrapper /usr/local/bin/abcl
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["abcl"]
