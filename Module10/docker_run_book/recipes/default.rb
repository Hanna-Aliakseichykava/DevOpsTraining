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


bash 'run_docker_container_8082' do
  code <<-EOH

    docker pull "myserver:5000/task7:#{node['APP_VERSION']}" 

    docker run -d -p 8082:8080 --name tomcat-container-8082 "task7:#{node['APP_VERSION']}"

    docker stop tomcat-container-8083
    docker rm tomcat-container-8083

    curl -s http://localhost:8082/app/ | grep --quiet "#{node['APP_VERSION']}"; [ \$? -eq 0 ]  && echo "Deployed on :8082" || echo "Failed to deploy on :8082"
  EOH
  action :run
  not_if 'sudo netstat -plnt | grep ":8082" &>/dev/null'
end


bash 'run_docker_container_8083' do
  code <<-EOH

    docker pull "myserver:5000/task7:#{node['APP_VERSION']}" 

    docker run -d -p 8083:8080 --name tomcat-container-8083 "task7:#{node['APP_VERSION']}"

    docker stop tomcat-container-8082
    docker rm tomcat-container-8082

    curl -s http://localhost:8083/app/ | grep --quiet "#{node['APP_VERSION']}"; [ \$? -eq 0 ]  && echo "Deployed on :8083" || echo "Failed to deploy on :8083"
  EOH
  action :run
  only_if 'sudo netstat -plnt | grep ":8082" &>/dev/null'
end