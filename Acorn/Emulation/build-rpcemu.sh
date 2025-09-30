#!/usr/bin/env bash

# ------------------------------------------------------------------------------
#                                                                              -
#  Created by Fonic <https://github.com/fonic>                                 -
#  Date: 09/11/25 - 09/11/25                                                   -
#                                                                              -
# ------------------------------------------------------------------------------

# Globals
SCRIPT_DIR="$(dirname -- "$(realpath -- "$0")")"

# Process command line
if (( $# != 1 )); then
	echo "Usage:   ${0##*/} SOURCES-DIR"
	echo "Example: ${0##*/} rpcemu-0.9.5"
	exit 2
fi

# Change to sources directory
sources_dir="${SCRIPT_DIR}/$1/src/qt5"
cd -- "${sources_dir}" || { echo "Error: failed to change directory to '${sources_dir}', aborting."; exit 1; }

# Patch sources
sed -i "s|CONFIG += debug_and_release|CONFIG += debug_and_release dynarec|g" rpcemu.pro
sed -i "s|typedef int bool;|//typedef int bool;|g" ../hostfs.c

# Configure and make sources
make clean
rm Makefile*
qmake .
make -j$(nproc)
