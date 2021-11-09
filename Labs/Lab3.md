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
3. Click on the Start trial button and confirm by clicking on Start my trial.
4. Click on the main menu to bring out the fly out.
<img src="/Labs/images/main.png" width="120">

5. Select on Machine Learning on the left panel
<img src="/Labs/images/ML.png" width="300">

6. Select Anomaly Detection

7. Click on the Create job button

<img src="/Labs/images/createnewjob.png" width="800">

8. Type in `filebeat` and select `filebeat-*`

9. Select Nginx Access Log 

<img src="/Labs/images/nginx.png" width="400">

10. Type in `nginx_` for Job ID prefix

11. Click on the Create Jobs button to start the jobs.

12. We are done.  Please terminate filebeat.


Let's look at the results together.

### Load sample data

We will be working with the kibana ecommerce sample data.

1. In Kibana, Click on the main menu to bring out the fly out.
<img src="/Labs/images/main.png" width="120">

2. Click on Overview.
3. Click on Add data.

<img src="/Labs/images/addsampledata.png" width="400">

4. Select Sample data.



3. Click on Add data in the Sample Web Logs pane

<img src="/Labs/images/ecommerce.png" width="400">

4. Go Stack Management > Transforms
5. Click on Create your first transform
6. Under type, select Index pattern

<img src="/Labs/images/transform_index_pattern.png" width="400">

7. Select kibana_sample_data_ecommerce.  

8. Note, the job we are creating is a Pivot job. Under Group by, select terms(customer_full_name)

9. In aggregations, type in value_count(order_id) to select. Do the same for sum(products.taxful_price), sum(products.quantity), and click on Next to continue

<img src="/Labs/images/transform_pivot _agg.png" width="400">

10. Specify a TransformID and Destination index. Please ensure to create an index pattern. (I did not select an index pattern because I already have one.) Click on Next to continue.

<img src="/Labs/images/transform_details.png" width="400">

11. Click on Create and start.  

12. Click on Transform on the bottom of the page to go back to the transform jobs overview pane.

13. Expand the transform job that we just performed and selec the preview tab.  You can see our data laid out in tabular format.

14. Now, let's go create an outlier job by click on the Machine Learning, and select Data Frame Analytics

15. Click on Create your first data frame analytics job.

16. Type in name of the transform destination index.

<img src="/Labs/images/transform_outlier_index.png" width="400">

17. We will take the defaults here and click on continue here.

<img src="/Labs/images/transform_outlier_default.png" width="400">

18. Create a outlier Job by providing a name and click on continue.
<img src="/Labs/images/transform_outlier.png" width="400">
19. Click on continue in Validation

20. Click on Create to start the job immediately

21. Click on View Results to look at the results together.

<img src="/Labs/images/transform_outlier_result.png" width="400">


