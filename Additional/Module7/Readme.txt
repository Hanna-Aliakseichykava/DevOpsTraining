git update-index --chmod=+x ./gradleSample/gradlew, коммит, пуш
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

