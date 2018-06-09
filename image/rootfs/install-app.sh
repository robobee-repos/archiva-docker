#!/bin/bash
set -e

source /docker-entrypoint-utils.sh
set_debug

SOURCE=$1; shift
SHA_SUM=$1; shift

if [ -f "${SHA_SUM}" ]; then
    sha_check="sha256sum -c ${SHA_SUM}"
else
    sha_check="echo ${SHA_SUM} | sha256sum -c"
fi

name=$(basename $SOURCE)

cd /tmp
wget -nv "$SOURCE"
eval "${sha_check}"

cd ${ARCHIVA_SOURCE_DIR}
tar xf /tmp/$name
ln -s "${ARCHIVA_SOURCE_DIR}/apache-archiva-2.2.3" "${ARCHIVA_SOURCE_DIR}/archiva"
rm /tmp/$name
rm ${SHA_SUM}
