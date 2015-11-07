#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

if (( $# < 2 ))
then
    echo "usage: add-cmsis.sh project_root_dir controller_type"
    echo "example: bash add-stm32f7-cmsis.sh ~user/Projects/CortexM7 stm32f746xx"
    exit 1
fi

# project location
PROJECT_LOCATION=$1 # e.g. $HOME/Projects/ARM-CortexMx/CortexM7
DEST_LOCATION="${PROJECT_LOCATION}/xpacks/cmsis"
DEST_INCLUDE_DIR="${DEST_LOCATION}/include"
DEST_SOURCE_DIR="${DEST_LOCATION}/src"
PROJECT_CONFIG_DIR="${PROJECT_LOCATION}/include"

# package definitions
PACK_LOCATION="$HOME/Projects/xpacks/stm32f7-cmsis.git"
PACK_INCLUDE_DIR="${PACK_LOCATION}/Drivers/CMSIS/Device/ST/STM32F7xx/Include"
PACK_SOURCE_DIR="${PACK_LOCATION}/Drivers/CMSIS/Device/ST/STM32F7xx/Source/Templates"
PACK_GIT_HOME="https://github.com/xpacks/stm32f7-cmsis.git"

if [ ! -e ${PACK_LOCATION} ]
then
    mkdir -p ${PACK_LOCATION}
    git clone $PACK_GIT_HOME ${PACK_LOCATION}
fi

# package specific definitions
CMSIS_CORE_PACK_LOCATION="$HOME/Projects/xpacks/arm-cmsis-core.git"
CONTROLLER_MODEL=$2 # e.g.: stm32f746xx
CMSIS_CORE_PACK_GIT_HOME="https://github.com/xpacks/arm-cmsis-core.git"

if [ ! -e ${CMSIS_CORE_PACK_LOCATION} ]
then
    mkdir -p ${CMSIS_CORE_PACK_LOCATION}
    git clone $CMSIS_CORE_PACK_GIT_HOME ${CMSIS_CORE_PACK_LOCATION}
fi

# delete old components
rm -rf "${DEST_LOCATION}"

# create new dirs
mkdir -p "${DEST_INCLUDE_DIR}"
mkdir -p "${DEST_SOURCE_DIR}"

#copy required files
cp "${PACK_INCLUDE_DIR}"/cmsis_device.h "${DEST_INCLUDE_DIR}"
cp "${PACK_INCLUDE_DIR}"/stm32f7xx.h "${DEST_INCLUDE_DIR}"
cp "${PACK_INCLUDE_DIR}"/system_stm32f7xx.h "${DEST_INCLUDE_DIR}"
cp "${PACK_INCLUDE_DIR}"/$CONTROLLER_MODEL.h "${DEST_INCLUDE_DIR}"
cp "${PACK_SOURCE_DIR}"/system_stm32f7xx.c "${DEST_SOURCE_DIR}"
cp "${PACK_SOURCE_DIR}"/vectors_$CONTROLLER_MODEL.c "${DEST_SOURCE_DIR}"
cp "${CMSIS_CORE_PACK_LOCATION}/CMSIS/Include"/*.h "${DEST_INCLUDE_DIR}"

