#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

if (( $# < 1 ))
then
    echo "usage: add-stm32f7-hal.sh project_root_dir"
    echo "example: bash add-stm32f7-hal.sh ~user/Projects/CortexM7"
    exit 1
fi

# project location and definitions
PROJECT_LOCATION=$1
DEST_LOCATION="${PROJECT_LOCATION}/xpacks/stm32f7-hal"
DEST_INCLUDE_DIR="${DEST_LOCATION}/include"
DEST_SOURCE_DIR="${DEST_LOCATION}/src"
PROJECT_CONFIG_DIR="${PROJECT_LOCATION}/include"

# package definitions
PACK_LOCATION="$HOME/Projects/xpacks/stm32f7-hal.git"
PACK_INCLUDE_DIR="${PACK_LOCATION}/Drivers/STM32F7xx_HAL_Driver/Inc"
PACK_SOURCE_DIR="${PACK_LOCATION}/Drivers/STM32F7xx_HAL_Driver/Src"
PACK_GIT_HOME="https://github.com/xpacks/stm32f7-hal.git"

if [ ! -e ${PACK_LOCATION} ]
then
    mkdir -p ${PACK_LOCATION}
    git clone $PACK_GIT_HOME ${PACK_LOCATION}
fi

# delete old components
rm -rf "${DEST_LOCATION}"

# create new dirs
mkdir -p "${DEST_INCLUDE_DIR}"
mkdir -p "${DEST_INCLUDE_DIR}/Legacy"
mkdir -p "${DEST_SOURCE_DIR}"

#copy required files
cp "${PACK_INCLUDE_DIR}"/*.h "${DEST_INCLUDE_DIR}"
cp "${PACK_INCLUDE_DIR}/Legacy"/*.h "${DEST_INCLUDE_DIR}/Legacy"
cp "${PACK_SOURCE_DIR}"/*.c "${DEST_SOURCE_DIR}"

# copy configuration file
if [ ! -f "${PROJECT_CONFIG_DIR}"/stm32f7xx_hal_conf.h ]
then
    cp "${PACK_INCLUDE_DIR}"/stm32f7xx_hal_conf_template.h "${PROJECT_CONFIG_DIR}"/stm32f7xx_hal_conf.h
fi

