# O11y with the Elastic Stack

## Overview
* Setup Elasticsearch
* Setup Kibana
* Deploy APM server
* Deploy Metricbeat
* Deploy services + the front end app
* Explore APM, traces, Metrics, and Logs

### Setup Environment

When the vm starts, you are automatically placed in your home directory.  You should have a file called `setup.sh`. Please run the file:

```
./setup.sh
```

When prompted about storage usage, please input Y and hit enter.

### Setup Elasticsearch

In this exercise, we will set up Elasticsearch.  The Elasticsearch configuration file is located in `/home/ubuntu/elastic/elasticsearch-7.5.2`.  As you can see we are using the latest Elasticsearch, version 7.5.2

The configuration file is located in the `config` directory.  It is called conveniently, `elasticsearch.yml`.  Please follow these instructions to start your elasticsearch instance.

1. Click on the My lab button on the left if you have not done so.

<img src="/Labs/images/virtual_classroom_user_guide_lab-terminal.png" alt="virtual_class" width="500" height="300">

2. When the terminal comes up, you should be at `/home/ubuntu`
3. `cd elastic/elasticsearch-7.5.2/`
4. To start Elasticsearch, please run `bin/elasticsearch`

### Setup Kibana

We will start Kibana here. The Kibana configuration file is located at `elastic/kibana-7.5.2-linux-x86_64/config`.  You guessed it.  The configuration file is called `kibana.yml`.  Please follow these steps to run Kibana

1. Start a new terminal
2. Go to the Kibana directory `cd elastic/kibana-7.5.2-linux-x86_64/`
3. Start Kibana `bin/kibana`

### Setup Metricbeat

We will start Metricbeat.  By default, the system module is enabled. Namely, the ingest pipeline or collection of metrics and dashboard have been configured for us.

1. Start a new terminal
2. Go to the metricbeat directory, `cd elastic/metricbeat-7.5.2-linux-x86_64/`
3. Start metricbeat, `./metricbeat -e`

### APMServer

Let's start the APM server.  The APM server is actually just a shipper. It enrich and transform the events that are sent from APM agent and ingest them into Elasticsearch.

1. Start a new terminal
2. Go to the metricbeat directory, `cd elastic/apm-server-7.5.2-linux-x86_64/`
3. Start metricbeat, `./apm-server -e`

### Deploying Services and App

Before we start, we will need to install Java and nodejs. Ubuntu comes with legacy nodejs; it won't work with our React application.  Please run the following command to install JDK and nodejs.  Please enter Y when prompted.

1. Start a new terminal

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

3. Bring up two backend services written in Java, cardatabase and car-value-estimator. Our front is a React application call carfront.

*car database service*

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

*car value estimator service*

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

```
./install-pkgs.sh
npm start
```

in the constants.js file, set the server url using your public IP or DNS

enable rum in your apm.yml file



error Failed at the carfront@0.1.0 build script 'react-scripts build'.
error Make sure you have the latest version of node.js and npm installed.


  sudo apt-get update                                                      │························································
   90  sudo apt-get nodejs                                                      │························································
   91  sudo apt-get install nodejs                                              │························································
   92  sudo apt-get install npm                                                 │························································
  112  apt install -y make python build-essential                               │························································
  113  sudo apt install -y make python build-essential                          │························································
  118  sudo apt-get purge --auto-remove nodejs                                  │························································
  121  sudo apt-get install nodejs                                              │························································
  147  history | grep apt                                                       │························································
ubuntu@ip-172-31-26-67:~/apm/carfront/src$                                      │························································
────────────────────────────────────────────────────────────────────────────────┘························································
············································


