#
# Cookbook:: docker_run_book
# Recipe:: default
#

package 'yum-utils' do
  action :install
end

package 'lsof' do
  action :install
end

bash 'install_docker' do
  code <<-EOH
    echo "Debug: Install Docker" 
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum -y install docker-ce

    systemctl start docker
    systemctl enable docker

    sudo docker logout
    sudo docker login --username hannaautodockerid --password hannaautodockerid

    export DOCKER_REGISTRY_CONF=/etc/docker/daemon.json
    > $DOCKER_REGISTRY_CONF
    echo '{ "insecure-registries" : ["myserver:5000" ] }' >> $DOCKER_REGISTRY_CONF

    sudo systemctl daemon-reload
    sudo systemctl restart docker
  EOH
  action :run
  not_if 'yum -q list installed docker-ce &>/dev/null'
end


bash 'run_docker_container_on_available_port' do
  code <<-EOH

    if ! (lsof -i:8080);
    then

      docker pull "myserver:5000/task7:#{node['APP_VERSION']}"

      docker run -d -p 8080:8080 --name tomcat-container-8080 "myserver:5000/task7:#{node['APP_VERSION']}"

      docker stop tomcat-container-8081 || true && docker rm tomcat-container-8081 || true

    else

      docker pull "myserver:5000/task7:#{node['APP_VERSION']}"

      docker run -d -p 8081:8080 --name tomcat-container-8081 "myserver:5000/task7:#{node['APP_VERSION']}"

      docker stop tomcat-container-8080 || true && docker rm tomcat-container-8080 || true

    fi

  EOH
  action :run
end

bash 'check_version' do
  code <<-EOH
     sleep 3;
    (curl -X GET http://localhost:8080/app/ || curl -X GET http://localhost:8081/app/ || echo '') | grep "#{node['APP_VERSION']}"; [ $? -eq 0 ] || exit 2
  EOH
  action :run
end

