vagrant up --provision-with shell


on the server
'192.168.0.10 myserver'

on the node
192.168.0.10 my.chef.server
'192.168.0.10 myserver'

!!!! 'myserver' - name of the virtual box


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
sudo -s
chmod -R 777 /root
chmod -R 777 /root/chef-repo/cookbooks



cd /root/chef-repo/cookbooks

chef generate cookbook docker_install_book
cd docker_install_book
ls

cd recipes
ls
default.rb
-------------------------------

Add the cookbook to the Chef server:


cd /root/chef-repo/cookbooks


//upload cookbook
knife cookbook upload docker_install_book

//verify that cookbook is uploaded
knife cookbook list

//Add the recipe to node’s run list
knife node run_list add mynode1 "recipe[docker_install_book]"


//apply the configurations defined in the cookbook
//knife ssh 'name:mynode1' 'sudo chef-client' -x vagrant -P 'vagrant'
knife ssh 'name:mynode1' 'sudo chef-client --once -o docker_install_book' -x vagrant -P 'vagrant'


//Test docker installation on node
knife ssh 'name:mynode1' 'sudo docker -v' -x vagrant -P 'vagrant'


//chef-apply default.rb

------------------------


3) write tests


https://habr.com/ru/post/253139/

https://github.com/chefspec/chefspec/tree/master/examples


Unit:

cd /root/chef-repo/cookbooks/docker_install_book

//spec/unit/recipes/default_spec.rb

chef exec rspec -c




Inspec:

https://novicejava1.blogspot.com/2017/07/testing-chef-code-using-inspec.html

https://github.com/test-kitchen/kitchen-vagrant/commit/3178e84b65d3da318f818a0891b0fcc4b747d559


.kitchen.yml
docker_install_book/test/smoke/default/default_test.rb


cd /root/chef-repo/cookbooks/docker_install_book

//kitchen destroy
//kitchen test
kitchen verify


//delivery local smoke


//inspec init profile "my_smoke"
//inspec.yml

//inspec exec default_test.rb


//chmod -R 777 /root
//chmod -R 777 /root/chef-repo/cookbooks
----------------------

https://habr.com/ru/post/253139/



Integration:

kitchen verify
или
kitchen test.
