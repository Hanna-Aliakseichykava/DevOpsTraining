Install Jenkins plugin Active Choices plugin
	We can now generate parameters in runtime with Groovy 
	
-------------



2. Create cookbook to deploy greeting app as docker container:

(Assume we have already installed some web server(LB) and configured it to route traffic to 8080 or 8081 ports)

Cookbook should do:

Deploy new version of container on available port (8081 or 8080), need to detect which is available
(-p <available>:8080)

Stop and remove old container( in case if it is not first deploy)

Note: do not hardcode new image version, specify it in attributes/default.rb file



3. Create Jenkins job with parameter:

version (get list of image versions from docker registry)

Job should do:

checkout task10 branch

update attributes/default.rb, metadata.rb, <environment>.json file with selected version from job parameter(version)

upload updated cookbook to chef server, upload updated environment file to chef server, push changes to github task10
branch

start chef-client

Should be commited: cookbook, Jenkinsfile, script.groovy (get list of versions)





-----------------

1) Install SSH Pipeline Steps plugin

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

