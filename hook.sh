#!/bin/sh
# post push certificate into Rekor 
while read oval nval ref
do
	if expr "$oval" : '0*$' >/dev/null
	then
		echo "Created a new ref, with the following commits:"
		git rev-list --pretty=oneline "$nval"
	else
		echo "New commits:"
		git rev-list --pretty=oneline "$nval" "^$oval"
	fi
	# back up the commit hash to attach a note
	commit=${nval}
done
# log signed push certificate, if any
if test -n "${GIT_PUSH_CERT-}" && test ${GIT_PUSH_CERT_STATUS} = G
then
	(
		echo "Posting push certificate to Rekor"
		COSIGN_EXPERIMENTAL=1 ./cosign sign-blob -key cosign.key <(git cat-file -p ${GIT_PUSH_CERT})
		echo "serializing certificate as a note"
		# FIXME: this works as an example, but probably you'd like to attach
		# the note to a special place (not the last pushed ref)
		# FIXME: do note that this happens on the server side, so the note will
		# not exist anywhere else. Ideally we could send the note to a CAS for
		# inspection.
		git notes add -C "${GIT_PUSH_CERT}" "${commit}"
		echo "Push certificate is ${GIT_PUSH_CERT} ${commit}"
	)
fi
exit 0
