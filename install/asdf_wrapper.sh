#! /bin/bash
if [[ -z "${ASDF_DIR}" ]]; then
  . "$HOME/.asdf/asdf.sh"
fi

"$HOME/.asdf/bin/asdf" "${@}"
