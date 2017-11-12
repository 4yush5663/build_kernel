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
DEVICE=$code_name
OWNER=4yush5663
NOW=`date "+%d%m%Y-%H%M%S"`

echo "Enter path to TOOLCHAINS" ; echo "e.g {/home/android/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-}"
read $toolchain
sleep 2
echo "Enter config file name "
read $config
sleep 2
echo "Now enter dvice code name"
read $code_name
sleep 2

export CROSS_COMPILE=$toolchain
export ARCH=arm

KERNEL_PATH=$(pwd)
KERNEL_ZIP=${KERNEL_PATH}/kernel_zip
KERNEL_ZIP_NAME=${NAME}-${VERSION}-${DEVICE}-${OWNER}-${NOW}-${PREFIX}
MODULES=${KERNEL_PATH}/drivers

JOBS=`grep processor /proc/cpuinfo | wc -l`

function make_zip() {
	cd ${KERNEL_PATH}/kernel_zip
	zip -r ${KERNEL_ZIP_NAME}.zip ./
	mv ${KERNEL_ZIP_NAME}.zip ${KERNEL_PATH}
}

function build_kernel() {
	make ${DEFCONFIG}
	make -j${JOBS}
	find ${KERNEL_PATH}/drivers -name "*.ko" -exec cp -f {} ${KERNEL_ZIP}/system/lib/modules \;
	find ${KERNEL_PATH} -name zImage -exec cp -f {} ${KERNEL_ZIP}/tools \;
}

function make_clean(){
	find ${KERNEL_PATH} -name zImage -exec rm -f {} \;
	find ${KERNEL_PATH} -name "*.ko" -exec rm -f {} \;
	make mrproper && make clean
	rm  ${KERNEL_PATH}/*.zip
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
echo "  1  = Delete .config & delete .zip"
echo "  2  = Start building kernel"
echo "  3  = Make zImage to flashable.zip" 
echo "  4  = Do 2-3 process"
echo
echo "================================================"
echo -e $COLOR_YELLOW"NOTE : JUST CHOOSE THE NUMBER,"
echo "       AND WAIT UNTIL PROCESS DONE!"
echo "================================================"
read -p "$COLOR_BLUE Whats Your Choice? " -n 1 -s x
echo -e $COLOR_GREEN

case "$x" in
	1)
		make_clean
		exit
		;;
	2)
		build_kernel
		exit
		;;
	3)
		make_zip
		exit
		;;
	4)
		build_kernel
		make_zip
		exit
		;;
	esac

exit
