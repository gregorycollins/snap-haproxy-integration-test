FROM fedora:21
ADD haproxy-integration-test /haproxy-integration-test
EXPOSE 80
CMD ["/haproxy-integration-test", "--proxy=haproxy", "--access-log=-", "--error-log=stderr", "--port=80"]
