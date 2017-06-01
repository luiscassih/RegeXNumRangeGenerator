This a simple numeric range regex generator written in bash.
Right now it doesn't have any input validation.

Usage: ./RegexNumberGenerator.sh startRange endRange

Example:
Command: ./RegexNumberGenerator.sh 1 7000
Output: [1-9]|[1-9][0-9]|[1-9][0-9][0-9]|[1-6][0-9][0-9][0-9]|7000