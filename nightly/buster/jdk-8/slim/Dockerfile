#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM openjdk:8-jdk-slim-buster

ENV ABCL_COMMIT 9c0a9693ea933309e503266255edcde5cc76257c

WORKDIR /usr/local/src/

RUN set -x \
    # Install fetch deps
    && apt-get update \
    && apt-get install --no-install-recommends -y curl gnupg dirmngr \
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
    && (cd "abcl-$ABCL_COMMIT" && bash ./ci/create-abcl-properties.bash "openjdk$JAVA_MAJOR_VERSION" && ant && cp dist/* /usr/local/share/abcl ) \
    && rm -rf abcl* ant* apache-ant* \
    # Remove fetch deps
    && apt-get remove -y curl gnupg dirmngr \
    && rm -rf /var/lib/apt/lists/* \
    # Smoke test ABCL.
    && java -jar /usr/local/share/abcl/abcl.jar --batch --eval '(print (multiple-value-list (lisp-implementation-version)))'

WORKDIR /

COPY abcl-wrapper /usr/local/bin/abcl
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["abcl"]
