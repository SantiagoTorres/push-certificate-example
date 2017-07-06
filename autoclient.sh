mkdir client/
cd client/
git clone git://localhost/signed-repo.git
cd signed-repo/
git checkout -b test
touch testfile
git add .
git commit -m "test commit"
git push --sign=true origin test

