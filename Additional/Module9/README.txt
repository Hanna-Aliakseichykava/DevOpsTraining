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


Add the cookbook to the Chef server:

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

------------------------


3) write tests

https://habr.com/ru/post/253139/


Unit:

cd /root/chef-repo/cookbooks/docker_install_book

spec/unit/recipes/default_spec.rb

chef exec rspec -c



----------------------

https://habr.com/ru/post/253139/



Integration:

kitchen verify
или
kitchen test.



to run integration tests


    # Install vagrant to test cookbooks
    myserver.vm.provision "shell", inline: <<-SHELL

        echo "Debug: Install dependencies for Vagrant"
        cd /etc/yum.repos.d/
        wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
        yum update -y
        yum -y install epel-release
        yum -y install gcc make patch dkms qt libgomp
        dkms status
        yum -y install kernel-headers kernel-devel fontforge binutils glibc-headers glibc-devel
        yum -y install VirtualBox-5.1

        sudo /sbin/rcvboxdrv restart
        modprobe vboxdrv
        gpasswd -a vagrant vboxusers

        echo "Install Vagrant"
        wget https://releases.hashicorp.com/vagrant/1.8.6/vagrant_1.8.6_x86_64.rpm
        yum -y localinstall vagrant_1.8.6_x86_64.rpm
    SHELL

