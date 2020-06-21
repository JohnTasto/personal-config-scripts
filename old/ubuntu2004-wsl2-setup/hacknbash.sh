#!/bin/bash

UNAME="WSL2USER"

UUID=$(id -u "${UNAME}")
UGID=$(id -g "${UNAME}")
UHOME=$(getent passwd "${UNAME}" | cut -d: -f6)
USHELL=$(getent passwd "${UNAME}" | cut -d: -f7)

if [[ -p /dev/stdin || "${BASH_ARGC}" > 0 && "${BASH_ARGV[1]}" != "-c" ]]; then
  echo "Called with ${BASH_ARGC} arguments: ${@}" >> /home/john/hacknbash.log
  echo " -> Setting USHELL=/bin/bash" >> /home/john/hacknbash.log
  USHELL=/bin/bash
fi

if [[ "${PWD}" = "/root" ]]; then
  echo "PWD (${PWD}) is /root" >> /home/john/hacknbash.log
  echo " -> Changing directory to ${HOME}" >> /home/john/hacknbash.log
  cd "${UHOME}"
fi

# get pid of systemd
SYSTEMD_PID=$(pgrep -xo systemd)

# if we're already in the systemd environment
if [[ "${SYSTEMD_PID}" -eq "1" ]]; then
  echo "SYSTEMD_PID is 1" >> /home/john/hacknbash.log
  echo " -> Calling \"exec ${USHELL} $@\"" >> /home/john/hacknbash.log
  exec "${USHELL}" "$@"
  exit 0
fi

if [[ -z ${SYSTEMD_PID} ]]; then
  # start systemd
  /usr/bin/daemonize -l "${HOME}/.systemd.lock" /usr/bin/unshare -fp --mount-proc /lib/systemd/systemd --system-unit=basic.target

  # wait for systemd to start
  retries=50
  while [[ -z ${SYSTEMD_PID} && $retries -ge 0 ]]; do
    (( retries-- ))
    sleep .1
    SYSTEMD_PID=$(pgrep -xo systemd)
  done

  if [[ $retries -lt 0 ]]; then
    >&2 echo "Systemd timed out; aborting."
    exit 1
  fi
fi

# enter systemd namespace
echo "Calling \"exec /usr/bin/nsenter -t ${SYSTEMD_PID} -m -p --wd=${PWD} /sbin/runuser -s ${USHELL} ${UNAME} -- ${@}\"" >> /home/john/hacknbash.log
exec /usr/bin/nsenter -t "${SYSTEMD_PID}" -m -p --wd="${PWD}" /sbin/runuser -s "${USHELL}" "${UNAME}" -- "${@}"
