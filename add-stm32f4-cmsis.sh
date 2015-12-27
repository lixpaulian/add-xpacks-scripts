#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

if (( $# < 2 ))
then
    echo "usage: add-cmsis.sh project_root_dir controller_type"
    echo "example: bash add-stm32f4-cmsis.sh ~user/Projects/CortexM4 stm32f427xx"
    exit 1
fi

# project location
PROJECT_LOCATION=$1 # e.g. $HOME/Projects/ARM-CortexMx/CortexM4
DEST_LOCATION="${PROJECT_LOCATION}/xpacks/cmsis"
DEST_INCLUDE_DIR="${DEST_LOCATION}/include"
DEST_SOURCE_DIR="${DEST_LOCATION}/src"
DEST_CMSIS_DRIVERS_DIR="${DEST_LOCATION}/drivers"
PROJECT_CONFIG_DIR="${PROJECT_LOCATION}/include"

DRIVERS_DEST_LOCATION="${PROJECT_LOCATION}/xpacks/drivers"
DRIVERS_DEST_INCLUDE_DIR="${DRIVERS_DEST_LOCATION}/include"
DRIVERS_DEST_SOURCE_DIR="${DRIVERS_DEST_LOCATION}/src"

# package definitions
PACK_LOCATION="$HOME/Projects/xpacks/stm32f4-cmsis.git"
PACK_INCLUDE_DIR="${PACK_LOCATION}/Drivers/CMSIS/Device/ST/STM32F4xx/Include"
PACK_SOURCE_DIR="${PACK_LOCATION}/Drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates"
PACK_DRIVERS_DIR="${PACK_LOCATION}/CMSIS/Driver"
PACK_GIT_HOME="https://github.com/xpacks/stm32f4-cmsis.git"

if [ ! -e ${PACK_LOCATION} ]
then
    mkdir -p ${PACK_LOCATION}
    git clone $PACK_GIT_HOME ${PACK_LOCATION}
fi

# package specific definitions
CMSIS_PACK_LOCATION="$HOME/Projects/xpacks/arm-cmsis.git"
CMSIS_PACK_GIT_HOME="https://github.com/xpacks/arm-cmsis.git"

if [ ! -e ${CMSIS_PACK_LOCATION} ]
then
    mkdir -p ${CMSIS_PACK_LOCATION}
    git clone $CMSIS_PACK_GIT_HOME ${CMSIS_PACK_LOCATION}
fi

# delete old components
rm -rf "${DEST_LOCATION}"
rm -rf "${DRIVERS_DEST_LOCATION}"

# create new dirs
mkdir -p "${DEST_INCLUDE_DIR}"
mkdir -p "${DEST_SOURCE_DIR}"
mkdir -p "${DEST_CMSIS_DRIVERS_DIR}"
mkdir -p "${DRIVERS_DEST_INCLUDE_DIR}"
mkdir -p "${DRIVERS_DEST_SOURCE_DIR}"

#copy required files
cp "${PACK_INCLUDE_DIR}"/cmsis_device.h "${DEST_INCLUDE_DIR}"
cp "${PACK_INCLUDE_DIR}"/stm32f4xx.h "${DEST_INCLUDE_DIR}"
cp "${PACK_INCLUDE_DIR}"/system_stm32f4xx.h "${DEST_INCLUDE_DIR}"
cp "${PACK_INCLUDE_DIR}"/$2.h "${DEST_INCLUDE_DIR}"
cp "${PACK_SOURCE_DIR}"/system_stm32f4xx.c "${DEST_SOURCE_DIR}"
cp "${PACK_SOURCE_DIR}"/gcc/vectors_$2.c "${DEST_SOURCE_DIR}"
cp "${CMSIS_PACK_LOCATION}/CMSIS/Include"/*.h "${DEST_INCLUDE_DIR}"
cp "${CMSIS_PACK_LOCATION}/CMSIS/Driver/Include"/*.h "${DEST_CMSIS_DRIVERS_DIR}"
cp "${PACK_DRIVERS_DIR}"/*.h "${DRIVERS_DEST_INCLUDE_DIR}"
cp "${PACK_DRIVERS_DIR}"/*.c "${DRIVERS_DEST_SOURCE_DIR}"


