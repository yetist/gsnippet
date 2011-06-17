#!/bin/sh

# Copyright (C) 2011  yetist <yetist@gmail.com>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

VERSION="0.2"
UPDATE_TOOL="../bin/kindle_update_tool.py"
INSTALLER="install.sh"
OUTPUT="./bin"
TEMP="./webkit"

echo Cleaning up
rm -rf ${OUTPUT}
mkdir ${OUTPUT}

echo Creating temporary folder
mkdir ${TEMP}

echo Packaging webpatch
cp README data/* scripts/* ${TEMP}

tar -zcvf webkit.tar.gz ${TEMP}

KINDLE_MODELS="k3g k3w k3gb"
for model in ${KINDLE_MODELS}; do
	${UPDATE_TOOL} c --${model} webpatch_${VERSION}_${model}_install install.sh webkit.tar.gz
done

rm -f webkit.tar.gz

mv update*bin ${OUTPUT}

7z a webpatch-${VERSION}.7z bin README
echo Cleaning up
rm -rf ${TEMP}
