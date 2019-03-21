#
# Cookbook:: docker_install_book
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

bash 'install_docker' do
  code <<-EOH
    echo "Debug: Install Docker" 
    yum install -y yum-utils
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum -y install docker-ce
  EOH
  action :run
end

bash 'install_docker_compose' do
  code <<-EOH
    echo "Debug: Install Docker Compose"
    curl -L https://github.com/docker/compose/releases/download/1.11.2/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  EOH
  action :run
end

bash 'start_docker' do
  code <<-EOH
    echo "Debug: Start Docker"
    systemctl start docker
    systemctl enable docker

    echo "Debug: Login Docker Hub"
    sudo docker logout
    sudo docker login --username hannaautodockerid --password hannaautodockerid
  EOH
  action :run
end

bash 'start_docker_registry' do
  code <<-EOH
    echo "Debug: Start Docker Registry"

    echo "Debug: Configure Docker Registry"
    [ ! -d "/etc/docker" ] && mkdir /etc/docker && echo "Folder /etc/docker has been created" || echo "Folder /etc/docker exists"
    export DOCKER_REGISTRY_CONF=/etc/docker/daemon.json
    echo 'Create or rewrite the file daemon.json'
    > $DOCKER_REGISTRY_CONF
    echo '{ "insecure-registries" : ["localhost:5000" ] }' >> $DOCKER_REGISTRY_CONF

    docker run -d -p 5000:5000 --restart=always --name registry registry:2
  
    sudo systemctl daemon-reload
    sudo systemctl restart docker

    firewall-cmd --permanent --zone=public --add-port=5000/tcp
    firewall-cmd --reload
    systemctl stop firewalld
  EOH
  action :run
end