
https://github.com/justlaputa/collectd-influxdb-grafana-docker

------------------------

# Install docker

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum -y install docker-ce


sudo curl -L https://github.com/docker/compose/releases/download/1.11.2/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


sudo systemctl start docker
sudo systemctl enable docker

---------------

Create folder to use with WinSCP

sudo mkdir /etc/DOCKER_DIR
sudo chmod -R 777 /etc/DOCKER_DIR

cd /etc/DOCKER_DIR

---------------


# login

sudo docker logout

sudo docker login --username <> --password <>

sudo docker login --username hannaaliakseichykava --password 14021989


#Build image:

#Note: Clean-up if already exists:

sudo docker images

docker container ls

docker stop parking-nn-container

docker rm parking-nn-container

docker rmi monitor-image

#Build image

docker build -t monitor-image .

#See available images

docker images

------------------



Registry: https://docs.docker.com/registry/

Swarm: https://docs.docker.com/engine/swarm/
Create service:
docker service create --name <name> --replicas <number> --publish 8080:8080 <image>

--------------
Grafana usage:

http://localhost:3000 (admin/admin)
• Add influxdb datasource
• Create Dashboard and add some metric

--------------
cd /etc/DOCKER_DIR
sudo -s

docker-compose up

docker-compose up --build


http://192.168.0.10:8083 influxdb admin page

add user and password for collectd db:
admin/admin

http://192.168.0.10:3000 grafana web page (login with admin/admin)

Add InfluxDb as datasource (http://docs.grafana.org/features/datasources/influxdb/):

url http://192.168.0.10:8086
database: collectd admin/admin


Create Dashboard and add some metric





cd /etc/DOCKER_DIR/log-collection-stack

sudo docker-compose --verbose up --build

sudo docker-compose --verbose up

sudo COMPOSE_HTTP_TIMEOUT=200 docker-compose up


Kibana
http://192.168.0.10:5601

https://github.com/maxyermayank/docker-compose-elasticsearch-kibana

curl http://localhost:9200/_nodes?pretty=true

http://192.168.0.10:9200


Access Kibana
http://localhost:5601
Accessing Kibana through Nginx
http://localhost:8089
------------------------


docker push <registry_ip>:5000/<image_name>:<version>