#!/bin/bash
set -e

source /docker-entrypoint-utils.sh
set_debug

LIB_DIR="${ARCHIVA_SOURCE_DIR}/archiva/lib"

if [[ "${DB_TYPE}" == "mysql" ]]; then
    cd "${LIB_DIR}"
    wget -O "mysql-connector-java-8.0.11.jar" "http://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/8.0.11/mysql-connector-java-8.0.11.jar"
fi
