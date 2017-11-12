#!/bin/bash
##
#  Copyright (C) 2015, Samsung Electronics, Co., Ltd.
#  Written by System S/W Group, S/W Platform R&D Team,
#  Mobile Communication Division.
##

set -e -o pipefail

DEFCONFIG=$defconfig
NAME=Team-BH
VERSION=v1
DEVICE=i9500
OWNER=4yush5663
NOW=`date "+%d%m%Y-%H%M%S"`

echo "Enter path to TOOLCHAINS" ; echo "e.g {/home/android/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-}"
read $toolchain
sleep 2
echo "Enter config file name "
read $config
sleep 2
#echo "Now enter dvice code name"
#read $code_name
sleep 2

export CROSS_COMPILE=$toolchain
export ARCH=arm

KERNEL_PATH=$(pwd)
KERNEL_ZIP=${KERNEL_PATH}/kernel_zip
KERNEL_ZIP_NAME=${NAME}-${VERSION}-${DEVICE}-${OWNER}-${NOW}-${PREFIX}
MODULES=${KERNEL_PATH}/drivers

JOBS=`grep processor /proc/cpuinfo | wc -l`

$boot= 

function build_kernel() {
	make ${DEFCONFIG}
	make -j${JOBS}
	find $
	find ${KERNEL_PATH}/drivers -name "*.ko" -exec cp -f {} ${KERNEL_ZIP}/system/lib/modules \;
	find ${KERNEL_PATH} -name zImage -exec cp -f {} ${KERNEL_ZIP}/tools \;
	cp -rf $boot ${KERNEL_ZIP}/;
	cd ${KERNEL_PATH}/kernel_zip
	zip -r ${KERNEL_ZIP_NAME}.zip ./
	mv ${KERNEL_ZIP_NAME}.zip ${KERNEL_PATH}
	
}

COLOR_RED=$(tput bold)$(tput setaf 1)
COLOR_BLUE=$(tput bold)$(tput setaf 4)
COLOR_YELLOW=$(tput bold)$(tput setaf 3)
COLOR_NEUTRAL="\033[0m"	
COLOR_GREEN="\033[1;32m"

clear
echo
echo -e $COLOR_RED"================================================"
echo -e $COLOR_BLUE"   BUILD SCRIPT FOR BUILDING KERNEL"
echo               "        MODIFIED BY 4yush5663"
echo -e $COLOR_RED"================================================"
echo
echo "  Kernel name     :  $NAME"
echo "  Kernel version  :  $VERSION"
echo "  Build user      :  $USER"
echo "  Build date      :  $NOW"
echo
echo "================================================"
echo -e $COLOR_BLUE"               Function menu flag"$COLOR_NEUTRAL
echo "================================================"
echo

echo "Hit enter to build"
read enter
build_kernel

exit
