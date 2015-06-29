#!/bin/bash

if [ ! -n "$WERCKER_GOVERALLS_TOKEN" ]; then
  error 'Please specify your Coveralls repository token'
  exit 1
fi

GIT_BRANCH=$WERCKER_GIT_BRANCH
if [ "$GIT_BRANCH" = "HEAD" ]; then
  GIT_BRANCH=$(git show -s --pretty=%d HEAD | cut -d , -f 3 | sed 's/[) ]//g')
fi

version=$(go version)
regex="(go[0-9].[0-9].[0-9])"
if [[ $version =~ $regex ]]; then
  version=${BASH_REMATCH[1]}
else
  fail 'Unable to determine Go version'
fi

if [[ "$version" < "go1.4.0" ]]; then
  go get code.google.com/p/go.tools/cmd/cover
else
  go get golang.org/x/tools/cmd/cover
fi
go get github.com/mattn/goveralls

echo "mode: count" > profile.cov
err=0

for dir in $(find . -maxdepth 10 -not -path './.git*' -not -path '*/_*' -type d); do
  if ls $dir/*.go &> /dev/null; then
    go test --covermode=count -coverprofile=profile.out $dir || err=1
    if [ -f profile.out ]; then
      cat profile.out | grep -v "mode: count" >> profile.cov
      rm profile.out
    fi
  fi
done

if [ "$err" -eq 0 ]; then
  goveralls -coverprofile=profile.cov -service=wercker.com -repotoken $WERCKER_GOVERALLS_TOKEN
else
  fail 'Coverage tests failed, skipping upload'
fi
