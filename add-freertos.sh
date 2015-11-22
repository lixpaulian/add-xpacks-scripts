#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

if (( $# < 3 ))
then
    echo "usage: add-freertos.sh project_root_dir cortex_port mem_mang_model"
    echo "example: bash add-freertos.sh ~user/Projects/CortexM7 CM7 4"
    echo "cortex ports: {CM0 | CM3 | CM3M | CM4 | CM7}"
    echo "memory management models: 0 to 5 (see FreeRTOS documentation)"
    exit 1
fi

case $2 in
    CM0) CORTEX_PORT="ARM_CM0"
;;
    CM3) CORTEX_PORT="ARM_CM3"
;;
    CM3M) CORTEX_PORT="ARM_CM3_MPU"
;;
    CM4) CORTEX_PORT="ARM_CM4F"
;;
    CM7) CORTEX_PORT="ARM_CM7/r0p1"
;;
    *) echo "Port not supported"
    exit 1
esac

echo "Found port $CORTEX_PORT... "

# project location and definitions
PROJECT_LOCATION=$1
DEST_LOCATION="${PROJECT_LOCATION}/xpacks/freertos"
DEST_INCLUDE_DIR="${DEST_LOCATION}/include"
DEST_SOURCE_DIR="${DEST_LOCATION}/src"
PROJECT_CONFIG_DIR="${PROJECT_LOCATION}/include"

# package definitions
PACK_LOCATION="$HOME/Projects/xpacks/freertos.git"
PACK_INCLUDE_DIR="${PACK_LOCATION}/FreeRTOS/Source/include"
PACK_SOURCE_DIR="${PACK_LOCATION}/FreeRTOS/Source"
PACK_GIT_HOME="https://github.com/lixpaulian/freertos.git"

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
cp "${PACK_INCLUDE_DIR}"/*.h "${DEST_INCLUDE_DIR}"
cp "${PACK_SOURCE_DIR}"/*.c "${DEST_SOURCE_DIR}"
cp "${PACK_SOURCE_DIR}/portable/GCC/${CORTEX_PORT}/port.c" "${DEST_SOURCE_DIR}"
cp "${PACK_SOURCE_DIR}/portable/GCC/${CORTEX_PORT}/portmacro.h" "${DEST_INCLUDE_DIR}"
cp "${PACK_SOURCE_DIR}/portable/MemMang/heap_$3.c" "${DEST_SOURCE_DIR}"
cp "${PACK_LOCATION}/FreeRTOS/CMSIS_RTOS/cmsis_os.c" "${DEST_SOURCE_DIR}"
cp "${PACK_LOCATION}/FreeRTOS/CMSIS_RTOS/cmsis_os.h" "${DEST_INCLUDE_DIR}"


# copy configuration file from template
if [ ! -f "${PROJECT_CONFIG_DIR}"/FreeRTOSConfig.h ]
then
    cp "${PACK_LOCATION}"/FreeRTOS/FreeRTOSConfig_template.h "${PROJECT_CONFIG_DIR}"/FreeRTOSConfig.h
fi
