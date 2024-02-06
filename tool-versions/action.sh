#! /bin/bash
readonly root=$( pwd )
readonly start_dir=${START_DIR:-.}

function set_env() {
  local -r var=$1
  shift

  if [[ -n "${GITHUB_ENV}" ]]; then
    echo "$var=$*" >> $GITHUB_ENV
  else
    echo "$var=$*"
  fi
}

function main() {
  local finished=false
  local -A versions

  cd "${start_dir}"

  until $finished; do
    if [[ -f .tool-versions ]]; then
      echo "Processing $(pwd)"
      while read plugin version; do
        if [[ -z "${versions[$plugin]}" ]]; then
          versions["$plugin"]="$version"
          echo "::notice::Found ${plugin} ${version}"
        fi
      done < .tool-versions
    fi

    if [[ $( pwd ) == "${root}" ]]; then
      finished=true
    else
      cd ..
    fi
  done

  if [[ -z "${!versions[@]}" ]]; then
    echo "::error::No tool versions found"
    exit 1
  else
    set_env ASDF_PLUGINS "${!versions[@]}"
    for plugin in "${!versions[@]}"; do
      set_env "${plugin^^}_VERSION" "${versions[$plugin]}"
    done

    echo Done.
  fi
}

main
