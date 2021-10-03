#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

declare -A refs=(
    [1.8.1]='master'
)

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

    if [[ $version = *rc ]]; then
        abclGitSha="$(curl -fsSL https://api.github.com/repos/armedbear/abcl/commits/master | jq -r .sha)"
        unset abclBinZipUrl
        unset abclBinZipSha
    else
        unset abclGitSha
        abclBinZipUrl="https://abcl.org/releases/$version/abcl-bin-$version.zip"
        abclBinZipSha="$(curl -fsSL "$abclBinZipUrl" | sha256sum | cut -d' ' -f1)"
    fi

    for v in \
        bullseye/{jdk-16,jdk-11,jdk-8}/{,slim} \
        buster/{jdk-16,jdk-11,jdk-8}/{,slim} \
        windowsservercore-{1809,ltsc2016}/{jdk-16,jdk-11,jdk-8}/ \
    ; do
        os="${v%%/*}"
        javaVariant="${v%/*}"
        javaVariant="$(basename "$javaVariant")"
        javaVersion="${javaVariant#jdk-}"
        javaType="${javaVariant%-*}"

        variant="${v##*/}"
        if [ -n "$variant" ]; then
            variantTag="-$variant"
        else
            variantTag=""
        fi

        dir="$version/$v"

        if [[ $version == *rc ]] && [[ "$os" == "windowsservercore"* ]]; then
            continue
        fi

        mkdir -p "$dir"

        case "$os" in
            bullseye|buster)
                template="apt$variantTag"
                cp "abcl-wrapper-jdk$javaVersion" "$dir/abcl-wrapper"
                cp docker-entrypoint.sh "$dir/docker-entrypoint.sh"
                if [ "$variant" != "slim" ]; then
                    cp install-quicklisp "$dir/install-quicklisp"
                fi
                ;;
            windowsservercore-*)
                template='windowsservercore'
                cp "abcl-wrapper-jdk$javaVersion.bat" "$dir/abcl-wrapper.bat"
                ;;
        esac

        if [[ $version == *rc ]]; then
            template="$template-nightly"
        fi

        tag="$javaVersion-$javaType$variantTag-$os"
        template="Dockerfile-${template}.template"

        { generated_warning; cat "$template"; } > "$dir/Dockerfile"

        if [[ $version == *rc ]]; then
            sed -ri \
                -e 's/^(FROM) .*/\1 '"openjdk:$tag"'/' \
                -e 's/^(ENV ABCL_COMMIT) .*/\1 '"$abclGitSha"'/' \
                "$dir/Dockerfile"
        else
            sed -ri \
                -e 's/^(ENV ABCL_VERSION) .*/\1 '"$version"'/' \
                -e 's/^(ENV ABCL_SHA256) .*/\1 '"$abclBinZipSha"'/' \
                -e 's/^(FROM) .*/\1 '"openjdk:$tag"'/' \
                "$dir/Dockerfile"
        fi
    done
done
