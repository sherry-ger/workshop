# Elastic Machine Learning

## Overview

* Load nginx logs
* Create Machine Learning jobs for nginx logs
* Review the results
* Outlier detection with Elastic ML

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

### Load Nginx logs

Please go ahead and load the nginx logs by running the following command

```
sudo chmod go-w /home/ubuntu/elastic/filebeat-7.5.2-linux-x86_64/modules.d/nginx.yml
cd /home/ubuntu/elastic/filebeat-7.5.2-linux-x86_64
./filebeat -e
```

### Validate the data in Kibana.

Let's take a look at what we have done so far.

1. Go to Setting on the upper right corner and click on Machine Info.

<img src="/Labs/images/MachineInfo.png" width="400">

2. Copy the Public DNS. 

<img src="/Labs/images/RemoteIP.png" width="400">

3. Paste the DNS into a browser, add the port number for kibana `:5601` and hit enter.
4. Go to the dashboards.

<img src="/Labs/images/dashboards.png" width="400">

5. In the searchbox, type in `filebeat nginx`
6. Select `[Filebeat Nginx] Overview ECS`
7. Be sure to change the date to last 1 year and click the Refresh button.

<img src="/Labs/images/dashboard2.png" width="400" height="250">

### Create machine learning jobs for nginx logs

Please follow these directions to create the jobs and we will take a look at them together when completed.

1. Go to the Management tab.

<img src="/Labs/images/management.png" width="300">

2. Select on License Management on the left
3. Click on the Start trial button and confirm in the popup dialog.
4. Select on Machine Learning on the left panel

<img src="/Labs/images/ML.png" width="300">

5. Click on the Create job button

<img src="/Labs/images/createnewjob.png" width="800">

6. Select on filebeat-*.  Note it is on page 2.

<img src="/Labs/images/filebeat.png" width="800">

7. Select Nginx Access Log

<img src="/Labs/images/nginx.png" width="400">

8. Type in `nginx_` for Job ID prefix
9. Click on the Create Jobs button to start the jobs.
10. We are done.  Please terminate filebeat.

Let's look at the results together.

### Load sample data

We will be working with the kibana ecommerce sample data.

1. In Kibana, click on the kibana icon.

<img src="/Labs/images/kibana_logo.png" width="300">

2. Click on Load a data set and a Kibana dashboard under Add sample data

<img src="/Labs/images/addsampledata.png" width="400">

3. Click on Add data in the Sample Web Logs pane

<img src="/Labs/images/ecommerce.png" width="400">

4. Go Kibana > Management tab and select transform under the Elasticsearch section.
5. Click on create your first transform.
6. Under type, select Index pattern

<img src="/Labs/images/transform_index_pattern.png" width="400">

7. Select kibana_sample_data_ecommerce.  

8. In the transform tab, under Group by, select customer_full_name.keyword

9. In aggregations, select order_id.value_count,taxful_total_price.sum, products.quantity.sum and click on Next

<img src="/Labs/images/transform_pivot _agg.png" width="400">

10. Specify a TranformID and Destination index. Please ensure to create an index pattern.  Click on Next to continue.

<img src="/Labs/images/transform_details.png" width="400">

11. Click on Create and start.  

12. Click on Tranform on the bottom of the page to go back to the transform jobs overview pane.

13. Expand the tranform job that we just performed and selec the preview tab.  You can see our data laid out in tabular format.

14. Now, let's go create an outlier job by click on the Machine Learning icon on the left hand side.

15. Select Data Frame Analytics on the top bar and click on Create your first data frame analytics job.

16. Create a outlier Job by providing a name, a source index and target index. Click on Create when ready and select Start when prompted.

<img src="/Labs/images/transform_outlier.png" width="400">

Let's look the results together.

<img src="/Labs/images/transform_outlier_result.png" width="400">


