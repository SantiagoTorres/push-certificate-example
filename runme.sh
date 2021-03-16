#!/usr/bin/bash 

source functions.sh
set -e #failerr

# clean up from possible previous iterations
cleanup server

# create our git repositoriy
mkdir -p server/signed-repo.git && cd server/signed-repo.git
git init --bare
touch git-daemon-export-ok  # git daemon only pushes repos with this magic file
git config receive.certNonceSeed 1000  # necessary for signed push
git config receive.certNonceSlop 1000  # necessary for signed push
# set up our post-receive hook to handle the certificates.
cp ../../hook.sh hooks/post-receive && chmod +x hooks/post-receive

# copy cosign into the receive hook
cp ../../cosign .
cp ../../cosign.key .

# actually listen. We will send the log to a logfile to avoid polluting our stdout 
git daemon --verbose --reuseaddr --informative-errors --enable=receive-pack \
    --base-path=$PWD/.. > server.log 2>server.err &
DAEMON_PID=$!

# go back to the root of the server dir
cd ..

# client side
echo "Ok, Done. You should now be able to clone+push on git://localhost/signed-repo.git"
if asksure "Do you want to automatically try this out?"; then
    source ../autoclient.sh
    tree ../../signed-repo.git/objects
else
    echo "ok, killing the server now..."
fi
