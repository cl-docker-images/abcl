#!/usr/bin/env bash
set -Eeuo pipefail

declare -A aliases=(
    [1.8.0]='1.8 latest'
    [1.7.1]='1.7'
)

defaultDebianSuite='buster'
defaultJavaVersion='15'

self="$(basename "$BASH_SOURCE")"
cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( */ )
versions=( "${versions[@]%/}" )
versions=( "${versions[@]/nightly}" )

# sort version numbers with highest first
IFS=$'\n'; versions=( $(echo "${versions[*]}" | sort -rV) ); unset IFS

# get the most recent commit which modified any of "$@"
fileCommit() {
	git log -1 --format='format:%H' HEAD -- "$@"
}

# get the most recent commit which modified "$1/Dockerfile" or any file COPY'd from "$1/Dockerfile"
dirCommit() {
	local dir="$1"; shift
	(
		cd "$dir"
		fileCommit \
			Dockerfile \
			$(git show HEAD:./Dockerfile | awk '
				toupper($1) == "COPY" {
					for (i = 2; i < NF; i++) {
						print $i
					}
				}
			')
	)
}

getArches() {
	local repo="$1"; shift
	local officialImagesUrl='https://github.com/docker-library/official-images/raw/master/library/'

	eval "declare -g -A parentRepoToArches=( $(
		find -name 'Dockerfile' -exec awk '
				toupper($1) == "FROM" && $2 !~ /^('"$repo"'|scratch|.*\/.*)(:|$)/ {
					print "'"$officialImagesUrl"'" $2
				}
			' '{}' + \
			| sort -u \
			| xargs bashbrew cat --format '[{{ .RepoName }}:{{ .TagName }}]="{{ join " " .TagEntry.Architectures }}"'
	) )"
}
getArches 'abcl'

cat <<-EOH
# this file is generated via https://github.com/cl-docker-images/abcl/blob/$(fileCommit "$self")/$self
Maintainers: Eric Timmons <nasafreak@gmail.com> (@etimmons)
GitRepo: https://github.com/cl-docker-images/abcl.git
EOH

# prints "$2$1$3$1...$N"
join() {
	local sep="$1"; shift
	local out; printf -v out "${sep//%/%%}%s" "$@"
	echo "${out#$sep}"
}

for version in "${versions[@]}"; do

	for v in \
        buster/{jdk-15,jdk-11,jdk-8} \
        windowsservercore-{1809,ltsc2016}/{jdk-15,jdk-11,jdk-8} \
    ; do
        os="${v%%/*}"
        javaVariant="$(basename "$v")"
        javaVersion="${javaVariant#jdk-}"
        javaType="${javaVariant%-*}"
        dir="$version/$v"

		[ -f "$dir/Dockerfile" ] || continue

		commit="$(dirCommit "$dir")"

		versionAliases=(
			$version
			${aliases[$version]:-}
		)

		variantAliases=( "${versionAliases[@]/%/-$javaType$javaVersion-$os}" )
        variantAliases=( "${variantAliases[@]//latest-/}" )

		case "$os" in
			windows*) variantArches='windows-amd64' ;;
			*)
				variantParent="$(awk 'toupper($1) == "FROM" { print $2 }' "$dir/Dockerfile")"
				variantArches="${parentRepoToArches[$variantParent]}"
				;;
		esac

        if [ "$javaVersion" = "$defaultJavaVersion" ]; then
            variantAliases+=( "${versionAliases[@]/%/-$javaType-$os}" )
            variantAliases+=( "${versionAliases[@]/%/-$os}" )
            variantAliases=( "${variantAliases[@]//latest-/}" )
        fi

		sharedTags=()

		if [ "$os" = "$defaultDebianSuite" ] || [[ "$os" == 'windowsservercore'* ]]; then
			sharedTags+=( "${versionAliases[@]/%/-$javaType$javaVersion}" )
            if [ "$javaVersion" = "$defaultJavaVersion" ]; then
                sharedTags+=( "${versionAliases[@]/%/-$javaType}" )
                sharedTags+=( "${versionAliases[@]}" )
            fi

            if [[ "$os" == "windowsservercore"* ]]; then
                sharedTags+=( "${sharedTags[@]/%/-windowsservercore}")
            fi
		fi

        sharedTags=( "${sharedTags[@]//latest-/}" )

		echo
		echo "Tags: $(join ', ' "${variantAliases[@]}")"
		if [ "${#sharedTags[@]}" -gt 0 ]; then
			echo "SharedTags: $(join ', ' "${sharedTags[@]}")"
		fi
		cat <<-EOE
			Architectures: $(join ', ' $variantArches)
			GitCommit: $commit
			Directory: $dir
		EOE
		[[ "$os" == "windows"* ]] && echo "Constraints: $os"
	done
done
