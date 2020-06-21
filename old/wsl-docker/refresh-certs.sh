#!/bin/bash

set -e

sd="$(dirname "$(readlink -f "$0")")"

source "$sd/../../util/term-colors.sh"

if ! (( ${EUID:-0} || "$(id -u)" )); then
  printf "${red}This script should not be run as root.${normal}\n" 1>&2
  exit 1
fi

password=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c 32)

export VERSION_CONTROL=t

root="$sd/.docker"

for path in ca daemon client; do
  if [[ -d $root/$path ]]; then
    mkdir -p "$root"
    rm -rf "/tmp/$root/$path"
    mkdir -p "/tmp/$root/$path"
    mv --backup --no-target-directory "/tmp/$root/$path" "$root/$path"
  else
    mkdir -p "$root/$path"
  fi
done

# CA Key
echo "${green}CA key${normal}"
openssl genrsa \
  -aes256 \
  -passout pass:$password \
  -out "$root/ca/ca-key.pem" \
  4096
chmod 0400 "$root/ca/ca-key.pem"

# CA Cert
echo "${green}CA certificate${normal}"
openssl req \
  -passin pass:$password \
  -new \
  -x509 \
  -days 365 \
  -key "$root/ca/ca-key.pem" \
  -sha256 \
  -out "$root/ca/ca.pem" \
  -subj '/C=US/ST=Oregon/L=Portland/O=LocalHostLLC/OU=IT/CN=localhost/emailAddress=test@localhost'
chmod 0444 "$root/ca/ca.pem"


daemon_subj='/CN=localhost'
client_subj='/CN=client'

echo subjectAltName = DNS:localhost > "$root/daemon/extfile.cnf"
echo extendedKeyUsage = serverAuth >> "$root/daemon/extfile.cnf"
echo extendedKeyUsage = clientAuth  > "$root/client/extfile.cnf"


for path in daemon client; do

  # Key
  echo "${green}$path key${normal}"
  openssl genrsa \
    -out "$root/$path/key.pem" \
    4096
  chmod 0400 "$root/$path/key.pem"

  # CSR
  echo "${green}$path CSR${normal}"
  subj="${path}_subj"
  openssl req \
    -subj "${!subj}" \
    -sha256 \
    -new \
    -key "$root/$path/key.pem" \
    -out "$root/$path/temp.csr"

  # Cert
  echo "${green}$path certificate${normal}"
  openssl x509 \
    -passin pass:$password \
    -req \
    -days 365 \
    -sha256 \
    -in "$root/$path/temp.csr" \
    -CA "$root/ca/ca.pem" \
    -CAkey "$root/ca/ca-key.pem" \
    -CAcreateserial \
    -out "$root/$path/cert.pem" \
    -extfile "$root/$path/extfile.cnf"
  chmod 0444 "$root/$path/cert.pem"

  rm "$root/$path/temp.csr" "$root/$path/extfile.cnf"
  ln $root/ca/ca.pem $root/$path
done

rm -f $root/ca/ca-key.pem $root/ca/ca.srl

mkdir -p ~/.docker
ln --backup --symbolic \
  "$root/client/ca.pem" \
  "$root/client/cert.pem" \
  "$root/client/key.pem" \
  ~/.docker
