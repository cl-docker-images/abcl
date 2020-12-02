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

    if [ "$version" = "nightly" ]; then
        abclGitSha="$(curl -fsSL https://api.github.com/repos/armedbear/abcl/commits/master | jq -r .sha)"
        unset abclBinZipUrl
        unset abclBinZipSha
    else
        unset abclGitSha
        abclBinZipUrl="https://abcl.org/releases/$version/abcl-bin-$version.zip"
        abclBinZipSha="$(curl -fsSL "$abclBinZipUrl" | sha256sum | cut -d' ' -f1)"
    fi

    for v in \
        buster/{jdk-15,jdk-11,jdk-8}/{,slim} \
        windowsservercore-{1809,ltsc2016}/{jdk-15,jdk-11,jdk-8}/ \
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

        if [ "$version" = "nightly" ] && [[ "$os" == "windowsservercore"* ]]; then
            continue
        fi

        mkdir -p "$dir"

        case "$os" in
            buster)
                template="apt$variantTag"
                cp "abcl-wrapper-jdk$javaVersion" "$dir/abcl-wrapper"
                cp docker-entrypoint.sh "$dir/docker-entrypoint.sh"
                ;;
            windowsservercore-*)
                template='windowsservercore'
                cp "abcl-wrapper-jdk$javaVersion.bat" "$dir/abcl-wrapper.bat"
                ;;
        esac

        if [ "$version" = "nightly" ]; then
            template="$template-nightly"
        fi

        tag="$javaVersion-$javaType$variantTag-$os"
        template="Dockerfile-${template}.template"

        { generated_warning; cat "$template"; } > "$dir/Dockerfile"

        if [ "$version" = "nightly" ]; then
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
