# Working with Kibana

## Overview

* Setup Elasticsearch
* Setup Kibana

### Setup Environment

When the vm starts, you are automatically placed in your home directory.  You should have a file called `setup.sh`. Please run the file:

```
./setup.sh
```

When prompted about storage usage, please input Y and hit enter. The command will pull the corresponding Elasticsearch and Kibana distributions.

### Setup Elasticsearch

In this exercise, we will set up Elasticsearch, our data store.  The Elasticsearch configuration file is located in `/home/ubuntu/elastic/elasticsearch-7.6.1`.  As you can see we are using the latest Elasticsearch, version 7.6.1

The configuration file is located in the `config` directory.  It is called conveniently, `elasticsearch.yml`.  Please follow these instructions to start your elasticsearch instance.

1. Click on the My lab button on the left if you have not done so.

<img src="/Labs/images/virtual_classroom_user_guide_lab-terminal.png" alt="virtual_class" width="500" height="300">

2. When the terminal comes up, you should be at `/home/ubuntu`
3. `cd elastic/elasticsearch-7.6.1/`
4. To start Elasticsearch from the command prompt, please run `bin/elasticsearch`

Please note, once you exit the terminal, the Elasticsearch instance is also terminated.

### Setup Kibana

We will start Kibana here. The Kibana configuration file is located at `elastic/kibana-7.6.1-linux-x86_64/config`.  You guessed it.  The configuration file is called `kibana.yml`.  Please follow these steps to run Kibana

1. Start a new terminal
2. Go to the Kibana directory `cd elastic/kibana-7.6.1-linux-x86_64/`
3. Start Kibana `bin/kibana`

Please note, once you exit the terminal, the Kibana instance will terminate.

### Access Kibana.

Let's see how we can access Kibana from the browser.

1. Go to Setting on the upper right corner and click on Machine Info.

<img src="/Labs/images/MachineInfo.png" width="400">

2. Copy the Public DNS. 

<img src="/Labs/images/RemoteIP.png" width="400">

3. Paste the DNS into a browser, **add the port number for kibana `:5601`* and hit enter.**


