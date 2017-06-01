#!/bin/bash
#Regex number range generator
#
#Usage: ./RegexNumberGenerator.sh startRange endRange
#
#Example:
#Command: ./RegexNumberGenerator.sh 1 7000
#Output: [1-9]|[1-9][0-9]|[1-9][0-9][0-9]|[1-6][0-9][0-9][0-9]|7000

numStart="$1"
numEnd="$2"


# returns to a resultFromStart variable
fromStart()
{
	resultFromStart="$1"
	for (( i=${#resultFromStart}-1; i>=0 ;i--)); do
		if [ "${resultFromStart:$i:1}" == "0" ]; then
			resultFromStart=$(echo ${resultFromStart:0:$i}"9"${resultFromStart:$i+1})
		else
			resultFromStart=$(echo ${resultFromStart:0:$i}"9"${resultFromStart:$i+1})
			break
		fi
	done
}

# returns to a resultFromEnd variable
fromEnd()
{
	resultFromEnd="$1"
	for (( i=${#resultFromEnd}-1; i>=0 ;i--)); do
		if [ "${resultFromEnd:$i:1}" == "9" ]; then
			resultFromEnd=$(echo ${resultFromEnd:0:$i}"0"${resultFromEnd:$i+1})
		else
			resultFromEnd=$(echo ${resultFromEnd:0:$i}"0"${resultFromEnd:$i+1})
			break
		fi
	done
}

leftBounds()
{
	leftBoundsStart="$1"
	leftBoundsEnd="$2"
	while ((leftBoundsStart < leftBoundsEnd )); do
		fromStart $leftBoundsStart
		result+=("$leftBoundsStart")
		result+=("$resultFromStart")
		leftBoundsStart=$((resultFromStart + 1))
	done
}

rightBounds()
{
	rightBoundsStart="$1"
	rightBoundsEnd="$2"
	while ((rightBoundsStart < rightBoundsEnd )); do
		fromEnd $rightBoundsEnd
		rightBoundsResult+=("$rightBoundsEnd")
		rightBoundsResult+=("$resultFromEnd")
		rightBoundsEnd=$((resultFromEnd - 1))
	done
}


result=()

#get leftBounds
leftBounds $numStart $numEnd

#remove last from left bounds
unset result[${#result[@]}-1]

#get rightBounds
rightBoundsResult=()
rightBounds ${result[@]: -1} $numEnd
#remove last from right bounds
unset rightBoundsResult[${#rightBoundsResult[@]}-1]

#echo ${rightBoundsResult[@]}

#reverse right bounds and join them to left bounds
for (( i=${#rightBoundsResult[@]}-1; i>=0; i-- )); do
	result+=("${rightBoundsResult[i]}")
done

parsedRegex=""
for (( i=0; i<=${#result[@]}-1;i=i+2 )); do
	#echo "${result[@]:$i:1} and ${result[@]:$i+1:1}"
	if (( i>0 )); then
		parsedRegex=$parsedRegex"|"
	fi
	currentChar="${result[@]:$i:1}"
	currentNextChar="${result[@]:$i+1:1}"
	for ((j=0;j<=${#currentChar}-1;j++)); do
		if [ ${currentChar:$j:1} == ${currentNextChar:$j:1} ]; then
			parsedRegex=$parsedRegex"${currentChar:$j:1}"
		else
			parsedRegex=$parsedRegex"[${currentChar:$j:1}-${currentNextChar:$j:1}]"
		fi
	done
done
echo "($parsedRegex)"