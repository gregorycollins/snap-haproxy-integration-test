#! /bin/sh

set -e
set -x

[ -f .cabal-sandbox/bin/haproxy-integration-test ] || {
    [ -d .cabal-sandbox ] || cabal sandbox init
    cabal install
    }

[ -f .cabal-sandbox/bin/haproxy-integration-test ] || exit 1

docker pull dockerfile/haproxy

cp -f .cabal-sandbox/bin/haproxy-integration-test test-app/
docker build -t snapframework/haproxy-test-app test-app
