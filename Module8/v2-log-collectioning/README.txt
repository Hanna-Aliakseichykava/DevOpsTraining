Добрый день


Добавила tomcat и filebeat в docker-контейнеры.

branch: Module8

Folder: Module8\v2-log-collectioning


Vagrant сейчас используется только чтобы установить Docker Manager (чтобы не устанавливать на локальной Windows-машине).

Я копирую файлы из v2-log-collectioning на Vagrant-машину (через WinSCP 192.168.0.10:22)

и запускаю log-collection стек (через Putty) командой

cd /etc/DOCKER_DIR/v2-log-collectioning

sudo COMPOSE_HTTP_TIMEOUT=300 docker-compose up




Filebeat и Tomcat контейнеры работают с shared volum-ом "logs".
У Tomcat он привязан к папке с логами tomcat-а: /usr/local/tomcat/logs
У Filebeat произвольная папка (/etc/filebeat/log) из которой логи отсылаются в logstash:
filebeat.yml: /etc/filebeat/log/*.log


Elastic:
http://192.168.0.10:9200/_cat/health

http://192.168.0.10:9200/_cat/indices?v

http://192.168.0.10:9200/logstash-*



Tomcat:
http://192.168.0.10:8080



Kibana (display 404 error): 

Go to:
http://192.168.0.10:8080/unexistent-app

Kibana
http://192.168.0.10:5601
elastic/changeme

(Screenshot in the repo, в v2-log-collectioning)

Кажется, у filebeat есть баг при чтениии файлов из shared volume: после того, как они подтянулись в первый раз, filebeat не видит изменений:
https://github.com/elastic/beats/issues/1361

(File didn't change: /etc/filebeat/log/localhost.2019-03-20.log)