FROM ubuntu:18.04

# On building image
RUN apt-get update
RUN apt-get install -y curl wget gnupg net-tools
RUN apt-get install -y apt-transport-https
RUN apt-get install -y adduser libfontconfig

RUN wget https://dl.grafana.com/oss/release/grafana_5.4.2_amd64.deb
RUN dpkg -i grafana_5.4.2_amd64.deb
RUN update-rc.d grafana-server defaults

# On starting container

CMD (service grafana-server start) && (service grafana-server status) && (cat /var/log/grafana/grafana.log) && (tail -f /dev/null)


EXPOSE 3000