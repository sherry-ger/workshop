#!/bin/bash
cat > /home/ubuntu/setup.sh << __EOF__
#!/bin/bash

##  Configure OS ##############################################################
echo
echo "Disabling swap..."
sudo swapoff -a
echo
echo "Increasing vm.max_map_count..."
sudo sysctl -w vm.max_map_count=262144

## Remove legacy nodejs ######################################################
sudo apt-get purge --auto-remove nodejs

mkdir /home/ubuntu/elastic
mkdir /home/ubuntu/workshop/data/logs
mkdir /home/ubuntu/apm
mkdir /home/ubuntu/apm/logs

cd /home/ubuntu/elastic

##  Install Elasticsearch, Kibana, and Filebeat ###############################
echo
echo "Installing Elasticsearch, Kibana, and Filebeat, Metricbeat, Logstash ..."

echo "Elasticsearch"
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.5.2-linux-x86_64.tar.gz
tar -xzf elasticsearch-7.5.2-linux-x86_64.tar.gz

echo "Kibana"
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.5.2-linux-x86_64.tar.gz
tar -xzf kibana-7.5.2-linux-x86_64.tar.gz

echo "Filebeat"
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.5.2-linux-x86_64.tar.gz
tar xzvf filebeat-7.5.2-linux-x86_64.tar.gz

echo "Metricbeat"
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.5.2-linux-x86_64.tar.gz
tar xzvf metricbeat-7.5.2-linux-x86_64.tar.gz

echo "Logstash"
curl -L -O https://artifacts.elastic.co/downloads/logstash/logstash-7.5.2.tar.gz
tar xzvf logstash-7.5.2.tar.gz

echo "APM Server"
curl -L -O https://artifacts.elastic.co/downloads/apm-server/apm-server-7.5.2-linux-x86_64.tar.gz
tar xzvf apm-server-7.5.2-linux-x86_64.tar.gz

##  Configure Elasticsearch and Kibana ########################################
echo
echo "Configuring Elasticsearch and Kibana..."
sed -i "s/^#\?cluster\.name:.*/cluster.name: \"elasticsearch-workshop\"/" /home/ubuntu/elastic/elasticsearch-7.5.2/config/elasticsearch.yml
sed -i "s/^#\?node\.name:.*/node.name: \"node-1\"/" /home/ubuntu/elastic/elasticsearch-7.5.2/config/elasticsearch.yml
sed -i "s/^#\?discovery\.seed_hosts:.*/discovery.seed_hosts: \[\"127.0.0.1\"\]/" /home/ubuntu/elastic/elasticsearch-7.5.2/config/elasticsearch.yml
echo "discovery.type: single-node" >> /home/ubuntu/elastic/elasticsearch-7.5.2/config/elasticsearch.yml
echo "#xpack.security.enabled: true" >> /home/ubuntu/elastic/elasticsearch-7.5.2/config/elasticsearch.yml

echo "Kibana"
sed -i "s/^#\?server\.host:.*/server.host: \"0.0.0.0\"/" /home/ubuntu/elastic/kibana-7.5.2-linux-x86_64/config/kibana.yml
sed -i "s/^#\?elasticsearch\.hosts:.*/elasticsearch.hosts: \[\"http:\/\/127.0.0.1:9200\"\]/" /home/ubuntu/elastic/kibana-7.5.2-linux-x86_64/config/kibana.yml

##  Configure Filebeat ########################################################
echo
echo "Configuring Filebeat..."
sed -i "s/^  \?hosts:.*/  hosts: [\"127.0.0.1\"]/" /home/ubuntu/elastic/filebeat-7.5.2-linux-x86_64/filebeat.yml
sed -i "s/^#\?setup.dashboards.enabled:.*/setup.dashboards.enabled: true/" /home/ubuntu/elastic/filebeat-7.5.2-linux-x86_64/filebeat.yml

##  Configure Metricbeat ########################################################
echo
echo "Configuring Metricbeat..."
sed -i "s/^  \?hosts:.*/  hosts: [\"127.0.0.1\"]/" /home/ubuntu/elastic/metricbeat-7.5.2-linux-x86_64/metricbeat.yml
sed -i "s/^#\?setup.dashboards.enabled:.*/setup.dashboards.enabled: true/" /home/ubuntu/elastic/metricbeat-7.5.2-linux-x86_64/metricbeat.yml

##  Download Data ############################################################# 
echo
echo "Downloading data..."
sudo apt-get -y install unzip

## git data 
echo
echo "Download data ..."
cd /home/ubuntu
git clone https://github.com/sherry-ger/workshop.git
unzip /home/ubuntu/workshop/data/airbnb/calendar.csv.zip calendar.csv -d /home/ubuntu/workshop/data/airbnb/ 
unzip /home/ubuntu/workshop/data/airbnb/reviews.csv.zip reviews.csv -d /home/ubuntu/workshop/data/airbnb/
unzip /home/ubuntu/workshop/data/airbnb/listings.csv.zip listings.csv -d /home/ubuntu/workshop/data/airbnb/

## git apm repo
echo
echo "git clone APM"
cd /home/ubuntu/apm
git clone https://github.com/bvader/cardatabase.git
git clone https://github.com/bvader/car-value-estimator.git
git clone https://github.com/bvader/carfront.git

## Copy Config
cp -f /home/ubuntu/workshop/config/apm-server.yml /home/ubuntu/elastic/apm-server-7.5.2-linux-x86_64/apm-server.yml
cp -f /home/ubuntu/workshop/config/nginx.yml /home/ubuntu/elastic/filebeat-7.5.2-linux-x86_64/modules.d/nginx.yml
cp /home/ubuntu/workshop/config/filebeat_apm_logs.yml /home/ubuntu/apm/logs/filebeat_apm_logs.yml

__EOF__

chown ubuntu:ubuntu /home/ubuntu/setup.sh
chmod u+x /home/ubuntu/setup.sh

#su ubuntu -c  "/home/ubuntu/setup.sh"

exit
