#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )

generated_warning() {
    cat <<EOH
#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
EOH
}

for version in "${versions[@]}"; do

    abclBinZipUrl="https://abcl.org/releases/$version/abcl-bin-$version.zip"
    abclBinZipSha="$(curl -fsSL "$abclBinZipUrl" | sha256sum | cut -d' ' -f1)"

    for v in \
        buster/{jdk-15,jdk-11,jdk-8} \
        windowsservercore-{1809,ltsc2016}/{jdk-15,jdk-11,jdk-8} \
    ; do
        os="${v%%/*}"
        javaVariant="$(basename "$v")"
        javaVersion="${javaVariant#jdk-}"
        javaType="${javaVariant%-*}"
        dir="$version/$v"

        mkdir -p "$dir"

        case "$os" in
            buster)
                template="apt"
                cp abcl-wrapper "$dir/abcl-wrapper"
                cp docker-entrypoint.sh "$dir/docker-entrypoint.sh"
                ;;
            windowsservercore-*)
                template='windowsservercore'
                cp abcl-wrapper.bat "$dir/abcl-wrapper.bat"
                ;;
        esac

        tag="$javaVersion-$javaType-$os"
        template="Dockerfile-${template}.template"

        { generated_warning; cat "$template"; } > "$dir/Dockerfile"

        sed -ri \
            -e 's/^(ENV ABCL_VERSION) .*/\1 '"$version"'/' \
            -e 's/^(ENV ABCL_SHA256) .*/\1 '"$abclBinZipSha"'/' \
            -e 's/^(FROM) .*/\1 '"openjdk:$tag"'/' \
            "$dir/Dockerfile"
    done
done
