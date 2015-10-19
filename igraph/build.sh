#!/usr/bin/env bash

# Ensure we are not using MacPorts, but the native OS X compilers
export PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin

# This is really important. Conda build sets the deployment target to 10.5 and
# this seems to be the main reason why the build environment is different in
# conda compared to compiling on the command line. Linking against libc++ does
export MACOSX_DEPLOYMENT_TARGET="10.10"
export OS=osx-64

# Seems that sometimes this is required
chmod -R 777 .*

# fix some issue with pyqt
# http://stackoverflow.com/questions/20590113/syntaxerror-when-using-cx-freeze-on-pyqt-app
rm -rf ${PREFIX}/lib/python3.4/site-packages/PyQt4/uic/port_v2
mv ${PREFIX}/lib/python3.4/site-packages/PyQt4/uic/port_v3 ${PREFIX}/lib/python3.4/site-packages/PyQt4/uic/port_v2

${PREFIX}/bin/python setup.py install

exit 0
