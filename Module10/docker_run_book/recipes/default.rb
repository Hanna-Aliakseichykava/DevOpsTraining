#
# Cookbook:: docker_run_book
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

    docker pull "myserver:5000/task7:#{node['APP_VERSION']}" 

    docker run -d -p 8080:8080 --name tomcat-container-8080 "myserver:5000/task7:#{node['APP_VERSION']}"

    docker stop tomcat-container-8081 || true && docker rm tomcat-container-8081 || true

    docker ps

    sudo netstat -plnt | grep ":8080" &>/dev/null && echo "Deployed on :8080" || echo "Failed to deploy on :8080"
  EOH
  action :run
  not_if 'sudo netstat -plnt | grep ":8080" &>/dev/null'
end


bash 'run_docker_container_8081' do
  code <<-EOH

    docker pull "myserver:5000/task7:#{node['APP_VERSION']}" 

    docker run -d -p 8081:8080 --name tomcat-container-8081 "myserver:5000/task7:#{node['APP_VERSION']}"

    docker stop tomcat-container-8080 || true && docker rm tomcat-container-8080 || true

    docker ps

    sudo netstat -plnt | grep ":8081" &>/dev/null && echo "Deployed on :8081" || echo "Failed to deploy on :8081"
  EOH
  action :run
  only_if '( ! sudo netstat -plnt | grep ":8080" &>/dev/null ) && (! sudo netstat -plnt | grep ":8081" &>/dev/null )'
end