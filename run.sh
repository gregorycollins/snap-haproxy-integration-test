#! /bin/sh

set -e
set -x

rm -Rf tmp
mkdir -p tmp
DOCKER_ID=$(docker run --name=snap-haproxy-app -d snapframework/haproxy-test-app)
APP_IP=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' snap-haproxy-app)

cat <<EOF
Snap app running at ${APP_IP}:80, docker id is ${DOCKER_ID}.
EOF

rm -f tmp/haproxy.cfg
cat >tmp/haproxy.cfg <<EOF

global
  log 127.0.0.1 local0
  log 127.0.0.1 local1 notice
  chroot /var/lib/haproxy
  user haproxy
  group haproxy
  # daemon

defaults
  log global
  mode http
  option httplog
  option dontlognull
  timeout connect 5000ms
  timeout client 50000ms
  timeout server 50000ms
  errorfile 400 /etc/haproxy/errors/400.http
  errorfile 403 /etc/haproxy/errors/403.http
  errorfile 408 /etc/haproxy/errors/408.http
  errorfile 500 /etc/haproxy/errors/500.http
  errorfile 502 /etc/haproxy/errors/502.http
  errorfile 503 /etc/haproxy/errors/503.http
  errorfile 504 /etc/haproxy/errors/504.http

listen stats :80
  mode http
  stats enable
  stats uri /stats

  server snap1 ${APP_IP}:80 check-send-proxy check inter 10s send-proxy
EOF

docker kill snap-haproxy-proxy || true
docker rm snap-haproxy-proxy || true
PROXY_ID=$(docker run -p 8080:80 -d --name=snap-haproxy-proxy -v $(pwd)/tmp:/haproxy-override dockerfile/haproxy)
set +x
cat <<EOF
haproxy now running at http://localhost:8080/stats, docker id is ${PROXY_ID}
EOF
