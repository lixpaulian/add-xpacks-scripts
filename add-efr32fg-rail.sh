#! /bin/bash

# note: this script is valid vor RAIL version 1.1.0.0

set -euo pipefail
IFS=$'\n\t'

if (( $# < 1 ))
then
    echo "usage: add-efr32fg-rail.sh project_root_dir"
    echo "example: bash add-efr32fg-rail.sh"
    exit 1
fi

# project location and definitions
PROJECT_LOCATION=$1

# main destination directories
DEST_INCLUDE_DIR="${PROJECT_LOCATION}/xpacks/efr32fg/include"
DEST_SOURCE_DIR="${PROJECT_LOCATION}/xpacks/efr32fg/src"

# sub-dirs to copy files to
DEVICE_DIR="EFR32FG1P"
LIBRARY_DIR="emlib"
BSP_DIR="bsp"
RAIL_LIB="rail-lib"

# package definitions
PACK_LOCATION="$HOME/Projects/xpacks/efr32fg-rail.git"
PACK_GIT_HOME="https://github.com/lixpaulian/efr32fg-rail.git"

if [ ! -e ${PACK_LOCATION} ]
then
    mkdir -p ${PACK_LOCATION}
    git clone $PACK_GIT_HOME ${PACK_LOCATION}
fi

# delete old components
rm -rf "${PROJECT_LOCATION}/xpacks/efr32fg"

# create new dirs
mkdir -p "${DEST_INCLUDE_DIR}/${DEVICE_DIR}"
mkdir -p "${DEST_INCLUDE_DIR}/${LIBRARY_DIR}"
mkdir -p "${DEST_INCLUDE_DIR}/${RAIL_LIB}"

mkdir -p "${DEST_SOURCE_DIR}/${DEVICE_DIR}"
mkdir -p "${DEST_SOURCE_DIR}/${LIBRARY_DIR}"
mkdir -p "${DEST_SOURCE_DIR}/${RAIL_LIB}"

# copy required files
cp "${PACK_LOCATION}/submodules/Device/SiliconLabs/${DEVICE_DIR}/Include"/*.h "${DEST_INCLUDE_DIR}/${DEVICE_DIR}"
cp "${PACK_LOCATION}/submodules/${LIBRARY_DIR}/inc"/*.h "${DEST_INCLUDE_DIR}/${LIBRARY_DIR}"
cp "${PACK_LOCATION}"/submodules/rail_lib/common/*.h "${DEST_INCLUDE_DIR}/${RAIL_LIB}"
cp "${PACK_LOCATION}"/submodules/rail_lib/chip/efr32/*.h "${DEST_INCLUDE_DIR}/${RAIL_LIB}"
cp "${PACK_LOCATION}"/submodules/rail_lib/chip/efr32/rf/common/cortex/*.h "${DEST_INCLUDE_DIR}/${RAIL_LIB}"
find "${PACK_LOCATION}"/submodules/rail_lib/protocol -name '*.h' -exec cp '{}' "${DEST_INCLUDE_DIR}/${RAIL_LIB}" \;

cp "${PACK_LOCATION}/submodules/Device/SiliconLabs/${DEVICE_DIR}/Source"/*.c "${DEST_SOURCE_DIR}/${DEVICE_DIR}"
cp "${PACK_LOCATION}/submodules/${LIBRARY_DIR}/src"/*.c "${DEST_SOURCE_DIR}/${LIBRARY_DIR}"
cp "${PACK_LOCATION}"/lib/librail_efr32.a "${DEST_SOURCE_DIR}/${RAIL_LIB}"


