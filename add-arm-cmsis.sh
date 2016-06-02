#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

if (( $# < 1 ))
then
    echo "usage: add-arm-cmsis.sh project_root_dir"
    echo "example: bash add-arm-cmsis.sh ~user/Projects/CortexM7"
    exit 1
fi

# project location and definitions
PROJECT_LOCATION=$1
DEST_LOCATION="${PROJECT_LOCATION}/xpacks/arm-cmsis"
DEST_INCLUDE_DIR="${DEST_LOCATION}/include"

# package definitions
PACK_LOCATION="$HOME/Projects/xpacks/arm-cmsis.git"
PACK_INCLUDE_DIR="${PACK_LOCATION}/CMSIS/Include"
PACK_GIT_HOME="https://github.com/xpacks/arm-cmsis.git"

if [ ! -e ${PACK_LOCATION} ]
then
    mkdir -p ${PACK_LOCATION}
    git clone $PACK_GIT_HOME ${PACK_LOCATION}
fi

# delete old components
rm -rf "${DEST_LOCATION}"

# create new dirs
mkdir -p "${DEST_INCLUDE_DIR}"

#copy required files
cp -r "${PACK_INCLUDE_DIR}"/* "${DEST_INCLUDE_DIR}"

