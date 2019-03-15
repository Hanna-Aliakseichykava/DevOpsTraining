
https://github.com/justlaputa/collectd-influxdb-grafana-docker

------------------------

http://www.inanzzz.com/index.php/post/ms6c/collectd-influxdb-and-grafana-integration

https://www.digitalocean.com/community/tutorials/how-to-analyze-system-metrics-with-influxdb-on-centos-7

https://ops.tips/blog/initialize-grafana-with-preconfigured-dashboards/#configuring-grafana
https://github.com/cirocosta/sample-grafana/tree/master/grafana



cd /etc/DOCKER_DIR/monitoring-stack

sudo docker-compose up
sudo docker-compose up --build



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


vi /etc/grafana/config.ini
cd /etc/grafana/provisioning
cd /dashboards /var/lib/grafana/dashboards


http://192.168.0.10:3000/api/datasources


[
{
"id": 1,
"orgId": 1,
"name": "MyInfluxDB",
"type": "influxdb",
"typeLogoUrl": "public/app/plugins/datasource/influxdb/img/influxdb_logo.svg",
"access": "proxy",
"url": "http://192.168.0.10:8086",
"password": "admin",
"user": "admin",
"database": "collectd",
"basicAuth": false,
"isDefault": true,
"jsonData": {
"keepCookies": []
},
"readOnly": false
}
]


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


Elastic:

curl -s -f  http://localhost:9200/_cat/health
curl http://localhost:9200/_nodes?pretty=true

http://192.168.0.10:9200/_cat/health


https://github.com/maxyermayank/docker-compose-elasticsearch-kibana


http://192.168.0.10:9200
elastic/changeme

