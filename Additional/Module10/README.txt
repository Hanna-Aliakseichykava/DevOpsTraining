Install Jenkins plugin Active Choices plugin
	We can now generate parameters in runtime with Groovy 
	
-------------



Job should do:


checkout task10 branch
update attributes/default.rb, metadata.rb, <environment>.json file with selected version from job parameter(version)


upload updated cookbook to chef server, upload updated environment file to chef server, 
push changes to github task10 branch

start chef-client

Should be commited: cookbook, Jenkinsfile, script.groovy (get list of versions)





-----------------

http://192.168.0.10:8080
Get password: sudo vi /var/lib/jenkins/secrets/initialAdminPassword

1) Install Jenkins plugin SSH Pipeline Steps

2) Install Jenkins plugin Active Choices

2) Install Credentials Binding Plugin (or just verify that it is already installed)

Create credentials with the following ids:

Jenkins -> Credentials -> System -> Global credentials (unrestricted) -> Add Credentials:

gitcreds
nexuscreds  (admin/admin123)
tomcatcreds (vagrant/vagrant)


3) If groovy script is used instead of Jenkinsfile, uncheck "run in groovy sandbox" checkbox in Job configuration;


4) If groovy Jenkinsfile is used,

Navigate to jenkins > Manage jenkins > In-process Script Approval

Add:

method java.util.Properties getProperty java.lang.String
method java.util.Properties load java.io.InputStream
new java.io.File java.lang.String
new java.util.Properties
staticMethod org.codehaus.groovy.runtime.DefaultGroovyMethods newDataInputStream java.io.File



---------

http://192.168.0.10:8080
admin2/admin2

http://192.168.0.10:8088/app/


-------------------

Test Cookbook

//WinSCP
sudo -s
chmod -R 777 /root
chmod -R 777 /root/chef-repo/cookbooks



//unit test

cd /root/chef-repo/cookbooks/docker_run_book
chef exec rspec -c


Add the cookbook to the Chef server:

cd /root/chef-repo/cookbooks


//upload cookbook
knife cookbook upload docker_run_book

//verify that cookbook is uploaded
knife cookbook list

//Add the recipe to node’s run list
knife node run_list add mynode1 "recipe[docker_run_book]"


//apply the configurations defined in the cookbook
knife ssh 'name:mynode1' 'sudo chef-client --once -o docker_run_book' -x vagrant -P 'vagrant'


//Test docker installation on node
knife ssh 'name:mynode1' 'sudo docker -v' -x vagrant -P 'vagrant'

knife ssh 'name:mynode1' 'curl -X GET http://localhost:8082/app/' -x vagrant -P 'vagrant'

knife ssh 'name:mynode1' 'curl -X GET http://localhost:8083/app/' -x vagrant -P 'vagrant'

http://localhost:8082/app/
http://192.168.0.11:8083/app/




//Test docker image install on node

docker pull "myserver:5000/task7:0.0.11" 

docker run -d -p 8082:8080 --name tomcat-container-8082 "myserver:5000/task7:0.0.11"

docker stop tomcat-container-8083
docker rm tomcat-container-8083

docker ps



curl -X GET http://localhost:8083/app/


---------------------------

v2

//unit test

cd /root/chef-repo/cookbooks/docker_run_book
chef exec rspec -c



cd /root/chef-repo/cookbooks/docker_run_book && sudo berks install && berks upload


//sudo knife cookbook list -c /root/chef-repo/.chef/knife.rb


//Add the recipe to node’s run list
//knife node run_list add mynode1 "recipe[docker_run_book]"

//apply the configurations defined in the cookbook
knife ssh 'name:mynode1' 'sudo chef-client --once -o docker_run_book' -x vagrant -P 'vagrant'


//////


knife cookbook delete docker_run_book




cd /root/chef-repo/cookbooks/docker_run_book && sudo berks install && berks upload

knife ssh 'name:mynode1' 'sudo chef-client --once -o docker_run_book' -x vagrant -P 'vagrant'

vi :q/var/chef/cache/chef-stacktrace/var/chef/cache/chef-stacktrace.out

//////

test on the node:


docker pull "myserver:5000/task7:0.0.32" 

docker run -d -p 8080:8080 --name tomcat-container-8080 "myserver:5000/task7:0.0.32"

docker stop tomcat-container-8081 || true && docker rm tomcat-container-8081 || true

------------------------------

https://subscription.packtpub.com/book/networking_and_servers/9781785287947/1/ch01lvl1sec23/using-environments


cd /root/chef-repo/
knife node environment set mynode1 dev


knife environment from file /root/chef-repo/environments/dev.json -c /root/chef-repo/.chef/knife.rb




sudo knife environment list -c /root/chef-repo/.chef/knife.rb

sudo knife node list -E dev -c /root/chef-repo/.chef/knife.rb


Old:

sh "sudo knife node run_list add ${NODE_NAME} \"recipe[docker_run_book]\" -c /root/chef-repo/.chef/knife.rb"
sh "sudo knife ssh 'name:${NODE_NAME}' 'sudo chef-client --once -o docker_run_book' -x vagrant -P 'vagrant' -c /root/chef-repo/.chef/knife.rb"

New:


----------------------------------


Create chef repo:




cd /root

chef generate repo chef-repo
mkdir -p /root/chef-repo/.chef

chef-server-ctl org-delete testorganization
chef-server-ctl user-delete admin

chef-server-ctl user-create admin Hanna Aliakseichykava aleks.anna.ur@gmail.com 'admin123' --filename /root/chef-repo/.chef/admin.pem

chef-server-ctl org-create testorganization 'Test Organization, Inc.' --association_user admin --filename /root/chef-repo/.chef/testorganization-validator.pem






export KNIFE_CONF=/root/chef-repo/.chef/knife.rb

> $KNIFE_CONF

echo "current_dir = File.dirname(__FILE__)" >> $KNIFE_CONF
echo "log_level                :info" >> $KNIFE_CONF
echo "log_location             STDOUT" >> $KNIFE_CONF
echo "node_name                'admin'" >> $KNIFE_CONF
echo "client_key               '/root/chef-repo/.chef/admin.pem'" >> $KNIFE_CONF
echo "validation_client_name   'testorganization-validator'" >> $KNIFE_CONF
echo "validation_key           '/root/chef-repo/.chef/testorganization-validator.pem'" >> $KNIFE_CONF
echo "chef_server_url          'https://myserver/organizations/testorganization'" >> $KNIFE_CONF
echo "cache_type               'BasicFile'" >> $KNIFE_CONF
echo "cache_options( :path => '/root/chef-repo/.chef/checksums' )" >> $KNIFE_CONF
echo "cookbook_path            ['/root/chef-repo/.chef/../cookbooks']" >> $KNIFE_CONF


cd /root/chef-repo/

knife ssl fetch

knife ssl check 



sudo knife bootstrap "192.168.0.11" -N "mynode1" -x vagrant -P vagrant --sudo

knife client list