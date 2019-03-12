
https://github.com/justlaputa/collectd-influxdb-grafana-docker

------------------------



cd /etc/DOCKER_DIR/monitoring-stack

sudo docker-compose up
sudo docker-compose up --build

http://www.inanzzz.com/index.php/post/ms6c/collectd-influxdb-and-grafana-integration

https://www.digitalocean.com/community/tutorials/how-to-analyze-system-metrics-with-influxdb-on-centos-7


test collectd on Tomcat machine:

sudo service collectd status

sudo nmap -sU -p 25826 my.influxdb

sudo tcpdump -i eth0 -p -n dst port 25826


http://192.168.0.10:8083 influxdb admin page

add user and password for collectd db:
admin/admin


Grafana usage:

http://192.168.0.10:3000 (admin/admin)

• Add influxdb datasource  (http://docs.grafana.org/features/datasources/influxdb/):
Type: influxdb
url http://192.168.0.10:8086
database: collectd admin/admin
• Create Dashboard and add some metric


------------------------


cd /etc/DOCKER_DIR/log-collection-stack

Note:

Encrease used memory on Host Machine (VM Settings) above 2 GB
and update config:
sudo sysctl -w vm.max_map_count=262144


sudo docker-compose up

sudo docker-compose --verbose up --build

sudo docker-compose --verbose up

sudo COMPOSE_HTTP_TIMEOUT=300 docker-compose up

sudo COMPOSE_HTTP_TIMEOUT=300 docker-compose up --build


Kibana
http://192.168.0.10:5601
elastic/changeme

Accessing Kibana through Nginx
http://192.168.0.10:8089

https://github.com/maxyermayank/docker-compose-elasticsearch-kibana

curl http://localhost:9200/_nodes?pretty=true

http://192.168.0.10:9200
elastic/changeme

