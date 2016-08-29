#! /bin/bash
# 
# Copyright (C) 2015 Davide Pani (info@davidepani.com)
# This file is part of Fast image editor
# 
# Fast image editor is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or 
# any later version.
# 
# Fast image editor is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#  
# You should have received a copy of the GNU General Public License
# along with Fast image editor.  If not, see <http://www.gnu.org/licenses/>.

IFS="
"
. functions.sh

source=""
destination=""
width=""
watermarkImage=""
resizeImages=false
addWatermark=false
dataValid=true

while ! isVoid $1 && ! isVoid $2
do
	case "$1" in
		"-s" | "--source")
			source=$2
		;;
		"-d" | "--destination")
			destination=$2
		;;

		"-w" | "--width")
			width=$2
		;;
		
		"-wa" | "--watermark")
			watermarkImage=$2
		;;
	esac
	
	shift
	shift
done


if ! isValidSource $source || ! isValidDestination $destination 
then
	dataValid=false
fi

if ! isVoid $width
then
	if isValidSize $width
	then
		resizeImages=true
	else
		echo "The new width is not valid, I ignore it."
	fi
fi

if ! isVoid $watermarkImage
then
	if isValidWatermark $watermarkImage
	then
		addWatermark=true
	else
		echo "The watermark image is not valid, I ignore it."
	fi
fi

if ! $dataValid
then
	echo "Data not valid"
	printHelp
	exit 1
fi

pathLog="$destination/`date +"%Y_%m_%d-%H_%M"`.log"

for file in $source/*
do

	if checkTypeImage $file
	then

		if ! $resizeImages $action
		then
			#Take a image size
			width=`identify -verbose "$file" | grep Geometry| cut -d":" -f2 | cut -d" " -f2 | cut -d"x" -f1`
		fi
		
		#Copy and resize the image if the user want to resize it
		convert "$file" -resize $width "$destination/new_`basename $file`"

		if $addWatermark $action
		then
			widthTemp=$((width - width/10))
			convert "$watermarkImage" -matte -background none -rotate -30 -resize $widthTemp "$destination/temp_img"
			
			composite -gravity center "$destination/temp_img" "$destination/new_`basename $file`" "$destination/new_`basename $file`"
			rm "$destination/temp_img"
		fi

		echo "Image \"$file\" processed" >> $pathLog
	else
		echo "The file \"$file\" is not a valid image" >> $pathLog
	fi

done

echo "End script"
exit 0
