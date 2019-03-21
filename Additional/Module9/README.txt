vagrant up --provision-with shell


on the server
'192.168.0.10 my.chef.server'

on the node
192.168.0.10 my.chef.server
'192.168.0.10 my.chef.workstation'

Example

Chef Server   chefserver.itzgeek.local	192.168.12.11 

Chef Workstation (Chef Development Kit)   chefdk.itzgeek.local	192.168.12.12

Chef Client        chefclient.itzgeek.local	192.168.12.20



//chef server
//admin/admin

yum install -y wget curl git

wget https://packages.chef.io/stable/el/7/chef-server-core-12.10.0-1.el7.x86_64.rpm

rpm -ivh chef-server-core-*.rpm

chef-server-ctl reconfigure

chef-server-ctl status

//create an administrator

chef-server-ctl user-create admin Hanna Aliakseichykava aleks.anna.ur@gmail.com 'admin' --filename /etc/chef/admin.pem

//create an organization:
chef-server-ctl org-create testorganization 'Test Organization, Inc.' --association_user admin --filename /etc/chef/testorganization.pem

firewall-cmd --permanent --zone public --add-service http
firewall-cmd --permanent --zone public --add-service https
firewall-cmd --reload


//chef dk

wget https://packages.chef.io/files/stable/chefdk/2.0.28/el/7/chefdk-2.0.28-1.el7.x86_64.rpm

rpm -ivh chefdk-*.rpm

chef verify

//chef-client -v

chef --version

//(enable Chef manager feature)




//Knife
https://www.itzgeek.com/how-tos/linux/centos-how-tos/setup-chef-12-centos-7-rhel-7.html/2


knife bootstrap <IP> -N <server_name> -x root



//////////////////////////////////

chef workstation on windows

https://downloads.chef.io/chef-workstation/



1) Create folder structure for cookbook

chef generate cookbook my_docker_cookbook

or

knife cookbook create my_docker_cookbook -o .


2) Write some simple recipe

For installing and starting docker (configure daemon to use insecure-registry option)

https://www.linode.com/docs/applications/configuration-management/creating-your-first-chef-cookbook/


//WinSCP
chmod -R 777 /root
chmod -R 777 /root/chef-repo/cookbooks
chmod -R 777 /root/chef-repo/cookbooks/docker_install_book/recipes


cd /root/chef-repo/cookbooks

chef generate cookbook docker_install_book
cd docker_install_book
ls

cd recipes
ls
default.rb


To test the recipe, add the LAMP stack cookbook to the Chef server:

//WinSCP
chmod -R 777 /root/chef-repo/cookbooks/docker_install_book/recipes


//upload cookbook
knife cookbook upload docker_install_book

//verify that cookbook is uploaded
knife cookbook list

//Add the recipe to node’s run list
knife node run_list add mynode1 "recipe[docker_install_book]"


//apply the configurations defined in the cookbook
knife ssh 'name:mynode1' 'sudo chef-client' -x vagrant -P 'vagrant'

//Test docker installation on node
knife ssh 'name:mynode1' 'sudo docker -v' -x vagrant -P 'vagrant'


//chef-apply hello.rb

-------------

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


3) write tests

https://habr.com/ru/post/253139/




https://github.com/chefspec/fauxhai/tree/master/lib/fauxhai/platforms

Lets run our tests:
$ chef exec spec

//expect(chef_run).to run_bash('command').with_cwd('/home')

./spec/docker_recipe_spec.rb



require 'chefspec'

describe 'Install docker' do

  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '7.3.1611').converge(described_recipe) }

  it 'installs docker' do
    expect(chef_run).to run_bash('install_docker').with_cwd('/home')
  end

  it 'installs docker compose' do
    expect(chef_run).to run_bash('install_docker_compose').with_cwd('/home')
  end

  it 'starts docker' do
    expect(chef_run).to run_bash('start_docker').with_cwd('/home')
  end

  it 'starts docker_registry' do
    expect(chef_run).to run_bash('start_docker_registry').with_cwd('/home')
  end
end





