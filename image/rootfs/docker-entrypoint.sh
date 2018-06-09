#!/bin/bash
set -e

source /docker-entrypoint-utils.sh
set_debug
echo "Running as `id`"

$BASH_CMD /create_wrapper_conf.sh

copy_files "/conf-in" "${WEB_ROOT}/conf" "*.xml"
copy_files "/conf-in" "${WEB_ROOT}/conf" "*.conf"
copy_files "/libs-in" "${WEB_ROOT}/lib" "*.jar"
sync_dir ${ARCHIVA_SOURCE_DIR}/archiva ${WEB_ROOT}

cd "${WEB_ROOT}"
exec "${@}"
