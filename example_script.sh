#!/bin/sh

# Copyright 2021 Weihao Jiang
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

generate(){
	rm -f rule.yaml
	touch rule.yaml
	destv=", ${dest}"
	__front="  "
	if [ "$__payload" != "" ]; then
		echo 'payload:' > rule.yaml
		destv=""
	else
		echo 'rules:' > rule.yaml
	fi
	for cfg in $( cat domainlist.csv | tail -n +2 | sort | sed "s/\s*,\s*/,/g" | sed "s/\s\+/_/g" );
	do
		list=($( echo $cfg | sed "s/,/\n/g" ))
		if [ "${list[3]}" == "True" ]; then
			if [ "${__jac}" != "" ]; then
				continue
			fi
		fi
		echo "${__front} - ${list[2]^^}, ${list[1]}${destv}" >> rule.yaml
	done
}


usage() { echo "Hint: see usage with $0 -h" 1>&2;}

print_help() {
	echo "$0: Example domain list utilizing script"
	echo ""
	echo "Usage: $0 [-h] [-j] [-p | -d DESTINATION]"
	echo " -p  Generate payload if set."
	echo " -d  Redirect destination."
	echo " -j  Not redirecting jAccount enabled sites."
	echo " -h  Print this help."
	exit 0
}

while getopts ":d:pjh" o; do
	case "${o}" in
		d)
			if [ -z "$dp" ]; then
				echo "Wrong argument. Hint: see usage with $0 -h"
				exit 1
			fi
			dest=${OPTARG}
			dp=1
			;;
		p)
			if [ -z "$dp" ]; then
				echo "Wrong argument. Hint: see usage with $0 -h"
				exit 1
			fi
			__payload=1
			dp=1
			;;
		j)
			__jac=1
			;;
		h)
			print_help
			exit 0
			;;
		*)
			usage
			exit 0
			;;
	esac
done

usage

generate

