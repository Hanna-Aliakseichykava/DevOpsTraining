#
# Cookbook:: docker_install_book
# Recipe:: default
#

package 'yum-utils' do
  action :install
end


bash 'install_docker' do
  code <<-EOH
    echo "Debug: Install Docker" 
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum -y install docker-ce
  EOH
  action :run
  not_if 'yum -q list installed docker-ce &>/dev/null'
end

bash 'install_docker_compose' do
  code <<-EOH
    echo "Debug: Install Docker Compose"
    curl -L https://github.com/docker/compose/releases/download/1.11.2/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  EOH
  action :run
  not_if { ::File.exist?('/usr/local/bin/docker-compose') }
end

systemd_unit 'docker' do
  action [:enable, :restart]
end
 
bash 'login_to_docker' do
  code <<-EOH

    echo "Debug: Login Docker Hub"
    sudo docker logout
    sudo docker login --username hannaautodockerid --password hannaautodockerid
  EOH
  action :run
end


file '/etc/docker/daemon.json' do
  content '{ "insecure-registries" : ["myserver:5000" ] }'
  action :create_if_missing
end


bash 'run_docker_container_8080' do
  code <<-EOH

    docker run -d -p 8080:8080 --name tomcat-container-8080 task10:${VERSION}

    docker stop tomcat-container-8081
    docker rm tomcat-container-8081
  EOH
  action :run
  not_if 'sudo netstat -plnt | grep ":8080" &>/dev/null'
end


bash 'run_docker_container_8081' do
  code <<-EOH

    docker run -d -p 8081:8080 --name tomcat-container-8081 task10:${VERSION}

    docker stop tomcat-container-8081
    docker rm tomcat-container-8081
  EOH
  action :run
  not_if 'sudo netstat -plnt | grep ":8081" &>/dev/null'
end