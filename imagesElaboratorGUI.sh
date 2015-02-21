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
. functions.sh


action=`zenity --title "Select the action" --text="Select the action\t\t\t\t\t" --list --radiolist --column=Select --column=Action FALSE "Resize" FALSE "Add watermark" TRUE "Resize and add watermark"`

source=`zenity --file-selection --title="Select the source folder" --text="Select the source folder" --directory`

watermarkSource=""
newSize=""
if [[ "$action" != "Resize" ]]
then
	watermarkSource=`zenity --file-selection --title="Select the watermark image" --text="Select the watermark image"`
fi

if [[ "$action" != "Add watermark" ]]
then
	newSize=`zenity --entry --title="Insert the new width" --text="Insert the new width. Must to be an integer."`
fi

destination=`zenity --file-selection --title="Select the destination folder" --text="Select the destination folder" --directory`

{
if ! isVoid $watermarkSource && ! isVoid $newSize
then
	./imagesElaborator.sh "-s" $source "-d" $destination "-wa" $watermarkSource "-w" $newSize
elif [ ! -z "$watermarkSource" ]
then
	./imagesElaborator.sh "-s" $source "-d" $destination "-wa" $watermarkSource
else
	./imagesElaborator.sh "-s" $source "-d" $destination "-w" $newSize
fi

} | zenity --progress --pulsate --auto-close --no-cancel 

exitCodeProgram=${PIPESTATUS[0]}

case "$exitCodeProgram" in
	0)
		zenity --info --text="Program terminated"
	;;
	1)
		zenity --info --text="Data not valid"
	;;
	*)
		zenity --info --text="There was an error and it is not handled. The code error is: $exitCodeProgram"
	;;
esac

echo "End"

exit 0
