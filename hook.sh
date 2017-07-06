#!/bin/sh
# mail out commit update information.
while read oval nval ref
do
	if expr "$oval" : '0*$' >/dev/null
	then
		echo "Created a new ref, with the following commits:"
		git rev-list --pretty "$nval"
	else
		echo "New commits:"
		git rev-list --pretty "$nval" "^$oval"
	fi
done
# log signed push certificate, if any
if test -n "${GIT_PUSH_CERT-}" && test ${GIT_PUSH_CERT_STATUS} = G
then
	(
		echo expected nonce is ${GIT_PUSH_NONCE}
		git cat-file blob ${GIT_PUSH_CERT}
	)
fi
exit 0
