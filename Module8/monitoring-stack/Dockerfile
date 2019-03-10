FROM centos:7


# Install Grafana

RUN \
  yum install https://grafanarel.s3.amazonaws.com/builds/grafana-3.1.1-1470047149.x86_64.rpm -y && \
  /sbin/chkconfig --add grafana-server;

CMD ["service grafana-server start"]