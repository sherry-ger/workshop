# Elastic Machine Learning

## Overview

* Create Machine Learning jobs for nginx logs
* Review the results
* Outlier detection with Elastic ML

### Create machine learning jobs for nginx logs

Please follow these directions to create the jobs and we will take a look at them together when completed.

1. Go to the Stack Management tab.

<img src="/Labs/images/management.png" width="300">

2. Select on License Management on the left
3. Click on the Start trial button and confirm in the popup dialog.
4. Select on Machine Learning on the left panel

<img src="/Labs/images/ML.png" width="300">

5. Click on the Create job button

<img src="/Labs/images/createnewjob.png" width="800">

6. Select on filebeat-*.  Note it is on page 2.

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

10. Specify a TranformID and Destination index. Please ensure to create an index pattern. (I did not select index pattern because I already have one.) Click on Next to continue.

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


