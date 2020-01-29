# O11y with the Elastic Stack

## Overview
* Setup Elasticsearch
* Setup Kibana
* Deploy APM server
* Deploy Metricbeat
* Deploy services + the front end app
* Explore APM, traces, Metrics, and Logs

For this lab, we assume you have set up Elasticsearch and Kibana already. If not, please refer to [Lab 3](https://github.com/sherry-ger/workshop/blob/master/Labs/Lab3.md).

### Setup Metricbeat

We will start Metricbeat.  By default, the system module is enabled. Namely, the ingest pipeline or collection of metrics and dashboard have been configured for us.

1. Start a new terminal
2. Go to the metricbeat directory, `cd elastic/metricbeat-7.5.2-linux-x86_64/`
3. Start metricbeat, `./metricbeat -e`

### APMServer

Let's start the APM server.  The APM server is actually just a shipper. It enriches and transforms events that are sent from APM agents and forwards them to Elasticsearch.

1. Start a new terminal
2. Go to the metricbeat directory, `cd elastic/apm-server-7.5.2-linux-x86_64/`
3. Start metricbeat, `./apm-server -e`

### Deploying Services and App

Before we start, we will need to install Java and nodejs. Ubuntu comes with legacy nodejs; it won't work with our React application.  Please run the following command to install JDK and nodejs.  Please enter Y when prompted.

1. Start a new terminal and run through these commands.

```
sudo apt-get update
sudo apt-get install default-jdk
sudo apt install -y make python build-essential
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install nodejs
```

2. Before we start the exercise, let's make sure we have the right version of Java and nodejs

```
java -version
nodejs -v
npm -v
```

You should be running java 1.8.0_242, nodejs v10.18.1, npm 6.13.4.

3. Bring up two backend services written in Java, cardatabase and car-value-estimator. Our front end app is a React application called carfront.

**car database service**

```
cd /home/ubuntu/apm/cardatabase
./run-with-apm.sh>/home/ubuntu/apm/logs/cardatabase.log
```

Find your Public DNS or Public IP and put the following url into a browser.

```http://MY-PUBLIC-IP:8080/api/cars```

You should see something like the following:

```
[{"id":3,"brand":"Ford","model":"Mustang","color":"Red","registerNumber":"ADF-1121","year":2017,"price":59000,"marketEstimate":58321,"owner":{"ownerid":1,"firstname":"John","lastname":"Johnson"}},
{"id":4,"brand":"Nissan","model":"Leaf","color":"White","registerNumber":"SSJ-3002","year":2014,"price":29000,"marketEstimate":31998,"owner":{"ownerid":2,"firstname":"Mary","lastname":"Robinson"}},
{"id":5,"brand":"Toyota","model":"Prius","color":"Silver","registerNumber":"KKO-0212","year":2018,"price":39000,"marketEstimate":41556,"owner":{"ownerid":2,"firstname":"Mary","lastname":"Robinson"}}]
```

**car value estimator service**

For this service, let's start a new termial. Use the following commands to start car-value-estimator service.

```
cd /home/ubuntu/apm/car-value-estimator
./run-with-apm.sh>/home/ubuntu/apm/logs/car-value-estimator.log
```

Again, find your public IP or public DNS. Again, paste the following url into a browser.

```http://MY-PUBLIC-IP:8888/estimateValue?brand=Tesla&model=3&year=2019```

You should see something like the following:

```{"estimate":57862,"brand":"Tesla","model":"3","year":2019}```

4. Now we are ready to launch the front end application.  
  a. Start a new terminal.
  
  b. `cd /home/ubuntu/apm/carfront/src`
  
  c. Edit constants.js file by replacing localhost with your public IP or DNS.
  
  d. Edit rum.js file by replacing all localhost with your public IP or DNS.
  
  e. Now we are ready to start

```
cd ..
./install-pkgs.sh
npm start
```
5. Now go to `http://MY-PUBLIC-IP:3000` you should be able to see our app.  Go ahead, add a new car. Now go to Kibana > APM. Select the last 15 minutes and we should see our services and our front end. We can see traces from the front end to the backend services. 

6. One last thing, we will need to ingest the log into Elasticsearch so we can see log events with trace ID.
  a. Start a new terminal.
  b. Add the following ingest pipeline using Kibana > Dev Tools
  ```
  PUT _ingest/pipeline/geoip-info
  {
    "description": "Add geoip info",
    "processors": [
      {
        "geoip": {
          "field": "client.ip",
          "target_field": "client.geo",
          "ignore_missing": true
        }
      },
      {
        "geoip": {
          "field": "source.ip",
          "target_field": "source.geo",
          "ignore_missing": true
        }
      },
      {
        "geoip": {
          "field": "destination.ip",
          "target_field": "destination.geo",
          "ignore_missing": true
        }
      },
      {
        "geoip": {
          "field": "server.ip",
          "target_field": "server.geo",
          "ignore_missing": true
        }
      },
      {
        "geoip": {
          "field": "host.ip",
          "target_field": "host.geo",
          "ignore_missing": true
        }
      }
    ]
  }
  ```
  b. Run the following commands to start ingest the backend service logs using filebeat.
  
  ```
  sudo chmod go-w /home/ubuntu/apm/logs/filebeat_apm_logs.yml
  /home/ubuntu/elastic/filebeat-7.5.2-linux-x86_64/filebeat -e -c /home/ubuntu/apm/logs/filebeat_apm_logs.yml```

7. Now go to Kibana > APM > car-value-estimator and click on MarketEstimateController#estimateValue
8. Click on Actions and select show trace log

<img src="/Labs/images/tracelog.png" width="400">
