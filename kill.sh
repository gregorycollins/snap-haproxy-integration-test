#! /bin/sh

set -x

docker kill snap-haproxy-app
docker rm snap-haproxy-app
docker kill snap-haproxy-proxy
docker rm snap-haproxy-proxy
