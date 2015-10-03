#!/bin/bash

export DYLD_LIBRARY_PATH="${PREFIX}/lib"
export DYLD_FALLBACK_LIBRARY_PATH="${PREFIX}/lib"

${PYTHON} setup.py install || exit 1;
