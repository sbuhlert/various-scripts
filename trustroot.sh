#!/bin/bash
DIR=${TMPDIR}/trustroot.$$
mkdir -p ${DIR}
trap "rm -rf ${DIR}" EXIT
cat "$1" | (cd $DIR && split -p '-----BEGIN CERTIFICATE-----' - cert- )
for c in ${DIR}/cert-* ; do
   security -v add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "$c"
done
rm -rf ${DIR}
