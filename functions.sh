#! /bin/bash
# 
# Copyright (C) 2015 Davide Pani (info@davidepani.com)
# This file is part of ImagesElaborator
# 
# ImagesElaborator is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or 
# any later version.
# 
# ImagesElaborator is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#  
# You should have received a copy of the GNU General Public License
# along with ImagesElaborator.  If not, see <http://www.gnu.org/licenses/>.

IFS="
"


function isInt() {
	if echo "$1" | grep -q "[^0-9]"	
	then 
		return 1
	fi

	return 0
}

function isVoid(){
	if [ -z "$1" ]
	then
		return 0
	fi

	return 1
}

function isValidSize(){
	if ! isVoid $1 && isInt $1 && test $1 -gt 0
	then
		return 0
	fi
	
	return 1
}

function isValidPath(){
	if ! isVoid $1 && [ -d $1 ]
	then
	    	return 0
	fi

	return 1
}

function checkTypeImage() {
	shopt -s nocasematch
	if [[ $1 == *.png || $1 == *.jpeg || $1 == *.jpg ]]
	then
		shopt -u nocasematch
		return 0
	fi

	shopt -u nocasematch
	return 1
}

function isValidSource(){
	if isValidPath $1
	then
	    	return 0
	fi

	return 1
}

function isValidDestination(){
	if isValidPath $1
	then
	    	return 0
	fi

	return 1
}

function isValidImage() {
	if isVoid $1 || ! checkTypeImage $1
	then
		return 1
	fi

	return 0
}

function isValidWatermark(){
	if isValidImage $1
	then
		return 0
	fi
	
	return 1
}

function printHelp(){
	echo "Options"
	echo "    -s, --source"
	echo "        Is mandatory and it is the url of the images to edit"
	echo "    -d, --destination"
	echo "        Is mandatory and it is the folder where program saves the images edited"
	echo "    -w, --width"
	echo "        Set if you want to resize the images. Must to be an integer"
	echo "    -wa, --watermark"
	echo "        Set if you want to apply the watermark. Pass a valid image like wotermark to impress on the other images."
}
