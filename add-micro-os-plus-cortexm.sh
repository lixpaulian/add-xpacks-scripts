#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

if (( $# < 1 ))
then
    echo "usage: add-micro-os-plus-cortexm.sh project_root_dir"
    echo "example: bash add-micro-os-plus-cortexm.sh ~user/Projects/CortexM7"
    exit 1
fi

# project location and definitions
PROJECT_LOCATION=$1
DEST_LOCATION="${PROJECT_LOCATION}/xpacks/micro-os-plus-cortexm"
DEST_INCLUDE_DIR="${DEST_LOCATION}/include"
DEST_SOURCE_DIR="${DEST_LOCATION}/src"
PROJECT_CONFIG_DIR="${PROJECT_LOCATION}/include"

# package definitions
PACK_LOCATION="$HOME/Projects/xpacks/micro-os-plus-iii-cortexm.git"
PACK_INCLUDE_DIR="${PACK_LOCATION}/include"
PACK_SOURCE_DIR="${PACK_LOCATION}/src"
PACK_GIT_HOME="https://github.com/micro-os-plus/micro-os-plus-iii-cortexm.git"

if [ ! -e ${PACK_LOCATION} ]
then
    mkdir -p ${PACK_LOCATION}
    git clone $PACK_GIT_HOME ${PACK_LOCATION}
fi

# delete old components
rm -rf "${DEST_LOCATION}"

# create new dirs
mkdir -p "${DEST_INCLUDE_DIR}"
mkdir -p "${DEST_SOURCE_DIR}"

#copy required files
cp -r "${PACK_INCLUDE_DIR}"/* "${DEST_INCLUDE_DIR}"
cp -r "${PACK_SOURCE_DIR}"/* "${DEST_SOURCE_DIR}"

