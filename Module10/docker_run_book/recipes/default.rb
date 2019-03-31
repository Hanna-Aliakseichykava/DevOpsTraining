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

    systemctl start docker
    systemctl enable docker

    sudo docker logout
    sudo docker login --username hannaautodockerid --password hannaautodockerid
  EOH
  action :run
  not_if 'yum -q list installed docker-ce &>/dev/null'
end


file '/etc/docker/daemon.json' do
  content '{ "insecure-registries" : ["myserver:5000" ] }'
  action :create_if_missing
end



bash 'run_docker_container_on_available_port' do
  code <<-EOH
  
  
    if (sudo netstat -plnt | grep ":8080" &>/dev/null;)
    then
       
      docker pull "myserver:5000/task7:#{node['APP_VERSION']}" 

      docker run -d -p 8081:8080 --name tomcat-container-8081 "myserver:5000/task7:#{node['APP_VERSION']}"

      docker stop tomcat-container-8080 || true && docker rm tomcat-container-8080 || true

    else      

      docker pull "myserver:5000/task7:#{node['APP_VERSION']}" 

      docker run -d -p 8080:8080 --name tomcat-container-8080 "myserver:5000/task7:#{node['APP_VERSION']}"

      docker stop tomcat-container-8081 || true && docker rm tomcat-container-8081 || true

    fi

  EOH
  action :run
end