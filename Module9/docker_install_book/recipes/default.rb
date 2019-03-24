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
  content '{ "insecure-registries" : ["localhost:5000" ] }'
  action :create_if_missing
end


bash 'start_docker_registry' do
  code <<-EOH
    echo "Debug: Start Docker Registry"

    docker run -d -p 5000:5000 --restart=always --name registry registry:2
  
    systemctl start firewalld
    systemctl enable firewalld

    firewall-cmd --permanent --zone=public --add-port=5000/tcp
    firewall-cmd --reload

    sudo systemctl daemon-reload
    sudo systemctl restart docker
   
  EOH
  action :run
  not_if 'sudo netstat -plnt | grep ":5000" &>/dev/null'
end