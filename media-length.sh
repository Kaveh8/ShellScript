#!/bin/bash

# 	Copyright 2014 Kaveh Shahhosseini <Kaveh228@gmail.com>
        
#        This program is free software; you can redistribute it and/or modify
#        it under the terms of the GNU General Public License as published by
#        the Free Software Foundation; either version 2 of the License, or
#        (at your option) any later version.
#    
#        This program is distributed in the hope that it will be useful,
#        but WITHOUT ANY WARRANTY; without even the implied warranty of
#        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#        GNU General Public License for more details.
        
#        You should have received a copy of the GNU General Public License
#        along with this program; if not, write to the Free Software
#        Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#        MA 02110-1301, USA.

convert_len_to_sec()
{
	echo "$len" | grep "mn$" >/dev/null
	if [ $? -eq 0 ]; then
		hour=`echo $len | cut -d' ' -f1 | sed 's/h//g'`
		min=`echo $len | cut -d' ' -f2 | sed 's/mn//g'`
		seconds=$((($hour*3600)+($min*60)));
		return 0;
	fi
	echo "$len" | grep "s$" >/dev/null
	if [ $? -eq 0 ]; then
		min=`echo $len | cut -d' ' -f1 | sed 's/mn//g'`
		sec=`echo $len | cut -d' ' -f2 | sed 's/s//g'`
		seconds=$((($min*60)+$sec));
		return 0;
	fi
	echo "$len" | grep "ms$" >/dev/null
	if [ $? -eq 0 ]; then
		sec=`echo $len | cut -d' ' -f1 | sed 's/s//g'`
		seconds=$sec;
		return 0;
	fi
}
length_video()
{
	which mediainfo >>/dev/null
	if [ $? -ne 0 ]; then
		echo -e "madiainfo program not found.\nplease install it by typing \"sudo apt-get install mediainfo\" or \"yum install mediainfo\" or something like this depend on your distribution";
		exit 1;
	fi
	count=1;
	res=0;
	num=0;
	for i in $files
	do
 		if [ $count -eq 1 ]; then 
  			count=$(($count+1));
  			continue;
		fi
  		#execute the length of files
  		file $i | grep "video\|audio" >/dev/null
 		if [ $? -eq 0 ]; then
  			len=`mediainfo $i | grep Duration | uniq | awk '{print $3,$4}'`
  			convert_len_to_sec;
			num=$(($num+1))
  			res=$(($res+$seconds))
  		else
  			echo "not a video or audio file: $i" 
  		fi
 		
	done
  h=$(($res/3600));
	m=$((($res-($h*3600))/60));
	s=$(($res-(h*3600)-(m*60)))
	echo "$num files"
	echo "$h Hr $m Min $s Sec";
}
#function for calculate media size
size_video()
{
  	echo "not implemented yet"
}
if [ "$1" = -l ]; then
	files=$@
	length_video;
elif [ "$1" = -s ]; then
	files=$@
	size_video;
else
	echo "Usage: $0 -[ls] file..."
	exit 1;
fi
