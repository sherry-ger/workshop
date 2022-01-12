# Capturing and Visualizing APM, Metrics, and Logs

## Overview

* Setup Elasticsearch
* Setup Kibana
* Deploy Metricbeat to ingest system metrics to Elasticsearch
* APM Server
* Deploy Services and Application
* Deploy Filebeat to ingest application logs
* Validate data in Kibana

### Setup Environment

We will setup on the VM and pull down the tools and files that are required for this lab.

1. Click on the My lab button on the left if you have not done so.

<img src="/Labs/images/virtual_classroom_user_guide_lab-terminal.png" alt="virtual_class" width="700" height="400">

2. When the terminal comes up, you should be at `/home/ubuntu`

3. You should have a file called `setup.sh`. Please run the file:

```
./setup.sh
```

### Setup Elasticsearch

In this exercise, we will set up Elasticsearch.  The Elasticsearch is located in `/home/ubuntu/elastic/elasticsearch-7.16.2`.  As you can see we are using the latest Elasticsearch, version 7.16.2

The configuration file is located in the `config` directory.  It is called conveniently, `elasticsearch.yml`.  Please follow these instructions to start your elasticsearch instance.

1. From the local directory `/home/ubuntu`, please:

```cd elastic/elasticsearch-7.16.2/```

2. To start Elasticsearch, please run `bin/elasticsearch`

### Setup Kibana

We will start Kibana here. The Kibana configuration file is located at `elastic/kibana-7.16.2-linux-x86_64/config`.  You guessed it.  The configuration file is called `kibana.yml`.  Please follow these steps to run Kibana

1. Start a new terminal
<img src="/Labs/images/NewTerminal.png" alt="virtual_class" width="500" height="300">

2. Go to the Kibana directory `cd elastic/kibana-7.16.2-linux-x86_64/`
3. Start Kibana `bin/kibana`

### Setup Metricbeat

We will start Metricbeat.  By default, the system module is enabled. Namely, the ingest pipeline or collection of metrics and dashboard have been configured for us.

1. Start a new terminal
2. Go to the metricbeat directory, `cd elastic/metricbeat-7.16.2-linux-x86_64/`
3. Start metricbeat, `./metricbeat -e`

### Validate the data in Kibana.

Let's take a look at what we have done so far.

1. Go to Setting on the upper right corner and click on Machine Info.

<img src="/Labs/images/MachineInfo.png" width="400">

2. Copy the Public DNS or IP. We will be re-using the Public DNS or IP later for our services and application as well.

<img src="/Labs/images/RemoteIP.png" width="400">

3. Paste the DNS into a browser, add the port number for kibana `:5601` and hit enter, e.g. http://MY-PUBLIC-IP:5601
4. Go to the dashboards.

<img src="/Labs/images/dashboards.png" width="400">

5. Type in `metricbeat system` in the search bar and hit enter.
6. Select `[Metricbeat System] ECS Overview`
7. Click on Dashboards to go back.

<img src="/Labs/images/dashboards1.png" width="400">
### APMServer

Let's start the APM server.  The APM server is actually just a shipper. It enriches and transforms events that are sent from APM agents and forwards them to Elasticsearch.

1. Start a new terminal
2. Go to the metricbeat directory, `cd elastic/apm-server-7.16.2-linux-x86_64/`
3. Start APM server, `./apm-server -e`

### Deploying Services and Application

Our applicaton has two backend services written in Java and a front end using React.


**Car database service**

1. Start a new terminal
2. Go to the following directory and start the car database service
```
cd /home/ubuntu/apm/cardatabase
./run-with-apm.sh>/home/ubuntu/apm/logs/cardatabase.log
```
3. Find your Public DNS or Public IP and put the following url into a browser.

```http://MY-PUBLIC-IP:8080/api/cars```

You should see something like the following:

```
[{"id":3,"brand":"Ford","model":"Mustang","color":"Red","registerNumber":"ADF-1121","year":2017,"price":59000,"marketEstimate":58321,"owner":{"ownerid":1,"firstname":"John","lastname":"Johnson"}},
{"id":4,"brand":"Nissan","model":"Leaf","color":"White","registerNumber":"SSJ-3002","year":2014,"price":29000,"marketEstimate":31998,"owner":{"ownerid":2,"firstname":"Mary","lastname":"Robinson"}},
{"id":5,"brand":"Toyota","model":"Prius","color":"Silver","registerNumber":"KKO-0212","year":2018,"price":39000,"marketEstimate":41556,"owner":{"ownerid":2,"firstname":"Mary","lastname":"Robinson"}}]
```

**Car value estimator service**

1. Let's start a new termial. 
2. Use the following commands to start car-value-estimator service.
```
cd /home/ubuntu/apm/car-value-estimator
./run-with-apm.sh>/home/ubuntu/apm/logs/car-value-estimator.log
```
3. Again, find your public IP or public DNS. Again, paste the following url into a browser.

```http://MY-PUBLIC-IP:8888/estimateValue?brand=Tesla&model=3&year=2019```

You should see something like the following:

```{"estimate":57862,"brand":"Tesla","model":"3","year":2019}```

**Carfront React Frontend**

Now we are ready to launch the front end application.  
1. Start a new terminal.
2. Go to `cd /home/ubuntu/apm/carfront/src`

- Edit constants.js file by replacing localhost with your public IP or DNS.

```
export const SERVER_URL = 'http://182.186.115.37:8080/'   
```

- Edit rum.js file by replacing all localhost with your public IP or DNS.

```
  // Set custom APM Server URL (default: http://localhost:8200)      
  serverUrl: 'http://182.186.115.37:8200', 
  // For distributed tracing to different origin (CORS)  
  distributedTracingOrigins: ['http://182.186.115.37:8080'],     
```

3. Now we are ready to start

  ```
  cd /home/ubuntu/apm/carfront
  ./install-pkgs.sh
  npm start
  ```

4. Now go to `http://MY-PUBLIC-IP:3000` you should be able to see our app.  Go ahead, add a new car. Now go to Kibana > APM. Select the last 15 minutes and we should see our services and our front end. We can see traces from the front end to the backend services. 


### Setup Filebeat

We will set up filebeat6. 

1. We will like to collect geo information from our RUM. Let's add the following ingest pipeline into elasticsearch.
- Go to Kibana at http://MY-PUBLIC-IP:5601
- Go to Dev Tools
 <img src="/Labs/images/dev_tools.png" width="200">
 
- Add the following command in Dev Tools

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

- Click on the green button to execute.

 <img src="/Labs/images/execute-cmd.png" width="400">
 
2. Start a new terminal.
3. Run the following commands to start ingest the backend service logs using filebeat.
  
  ```
  /home/ubuntu/elastic/filebeat-7.16.2-linux-x86_64/filebeat -e -c /home/ubuntu/apm/logs/filebeat_apm_logs.yml
  ```

4. Now go to Kibana > APM > car-value-estimator and click on MarketEstimateController#estimateValue
5. Click on Actions and select show trace log

<img src="/Labs/images/tracelog.png" width="400">
