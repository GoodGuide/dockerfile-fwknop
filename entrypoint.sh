#!/bin/bash

set -e -x -u

create_config_files() {
  confd -onetime -log-level=debug
  chmod -c 0600 /etc/fwknop/*.conf
  fwknopd --exit-parse-config
}

main() {
  create_config_files

  if [[ $# -eq 0 || $1 =~ ^- ]]; then
    exec fwknopd -f "$@"
  else
    exec "$@"
  fi
}

main "$@"
