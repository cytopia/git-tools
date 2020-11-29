#!/bin/sh

set -e
set -u

# Commit, Branch or Tag
HEAD="$( git branch --no-color | grep '^\*' | sed 's|)||g' | xargs -n1 | tail -1 )"
echo "HEAD: ${HEAD}"

# Commit Hash
HASH="$( git rev-parse HEAD | grep -Eo '^[0-9a-zA-Z]{7}' )"
echo "HASH: ${HASH}"
echo "FROM: $( git branch --contains  "${HASH}" )"

# Hash is found in what Branch?
FROM="$( git branch --contains  "${HASH}" | head -2 | tac | head -1 | sed 's|^*[[:space:]]*||g' | sed 's|)||g' | xargs -n1 | tail -1 | xargs )"
echo "FROM: ${FROM}"

# How many commits behind FROM branch
BEHIND="$( git rev-list --count "${HASH}..${FROM}" )"
echo "BEHI: ${BEHIND}"


echo "REV:  $( git name-rev "${HEAD}" )"
echo "PNT:  $( git tag --points-at HEAD )"
echo


###
### TAG
###
if git name-rev "${HEAD}" | grep -E "^${HEAD} tags/${HEAD}" > /dev/null; then
	echo "GIT_NAME=${HEAD}"
	echo "GIT_TYPE=TAG"
	echo "GIT_HEAD=${HASH}"
	echo
	echo "DETACHED_FROM=${FROM}"
	echo "BEHIND=${BEHIND}"
###
### Branch or Detached Commit
###
else
	# Detached Commit (not latest in branch)
	if [ "${BEHIND}" -gt "0" ]; then
		echo "GIT_NAME=${HEAD}"
		echo "GIT_TYPE=COMMIT"
		echo "GIT_HEAD=${HASH}"
		echo
		echo "DETACHED_FROM=${FROM}"
		echo "BEHIND=${BEHIND}"
	else
		if [ "$( git branch | grep '^\*' | sed 's|^*[[:space:]]*||g' | xargs )" = "${FROM}" ]; then
			DETACHED=
		else
			DETACHED="${FROM}"
		fi
		echo "GIT_NAME=${FROM}"
		echo "GIT_TYPE=BRANCH"
		echo "GIT_HEAD=${HASH}"
		echo
		echo "DETACHED_FROM=${DETACHED}"
		echo "BEHIND=${BEHIND}"
	fi
fi
