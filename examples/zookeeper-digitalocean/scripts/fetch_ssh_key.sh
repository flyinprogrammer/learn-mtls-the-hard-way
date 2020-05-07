#!/bin/bash
set -euo pipefail

realpath() {
  OURPWD=$PWD
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  cd "$OURPWD"
  echo "$REALPATH"
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OUTPUTS_DIR=$(realpath "${DIR}/../outputs")
mkdir -p "${OUTPUTS_DIR}"
SSH_KEY="${OUTPUTS_DIR}/ec2_key.pem"

terraform output ssh_key > "${SSH_KEY}"
chmod 600 "${SSH_KEY}"
echo "Placed key here: ${SSH_KEY}"
