# Queries, Aggregations, and Elasticsearch SQL

## Overview

* Full Text Search Queries
* Combined queries
* Aggregations
* Elasticsearch SQL

### Prepare to run the queries

First thing first, please:

1. In Kibana, click on the kibana icon.

<img src="/Labs/images/kibana_logo.png" width="300">

2. Click on Load a data set and a Kibana dashboard under Add sample data

<img src="/Labs/images/addsampledata.png" width="400">

3. Click on Add data in the Sample Web Logs pane

<img src="/Labs/images/sampleweblog.png" width="400">

4. Go to Dev Tools

<img src="/Labs/images/dev_tools.png" width="300">

5. Copy and paste the following into Dev Tools Console

```
# see what indices are on the cluster
GET _cat/indices

# Querying with match, match_phrase, range and bool.

1. Write and execute a query that matches all the documents in the products index. The hits response should contain over 10000 hits, but notice you only get back 10 hits because the default value of "size" for a query is 10:

2. Add the "size" parameter to your previous search and set it to 100. You should now see 100 products in the results. 

```
GET products/_search
{
  "size": 100, 
  "query": {
    "match_all": {}
  }
}
```

3. Write and execute a match query for products that have the term "rice" in the productName field. 

```
GET products/_search
{
  "query": {
    "match": {
      "productName": "rice"
    }
  }
}
```

4. Now run a match query for "rice pilaf" in the productName field. 

```
GET products/_search
{
  "query": {
    "match": {
      "productName": "rice pilaf"
    }
  }
}
```

The search returns products with "rice" or "pilaf", so there are additional hits from documents with "pilaf" in the productName.

Your search for "rice pilaf" cast a very wide net. The top hits look good, but the precision is not great for many of the lower-scoring hits, especially those products that have "rice" in the name but not "pilaf". Change the operator of your previous match query to and, then run it again. Notice this changes the precision drastically.

```
GET products/_search
{
  "query": {
    "match": {
      "productName": {
        "query": "rice pilaf",
        "operator": "and"
      }
    }
  }
}
```

5. Run a query that answers the question: "Which products have vegetarian or baked or beans in the productName?"

```
GET products/_search
{
  "query": {
    "match": {
      "productName": "vegetarian baked beans"
    }
  }
}
```

6. Run a query that answers the question: "Which products have a productName that includes at least 2 of the terms vegetarian or baked or beans?" 

```
GET products/_search
{
  "query": {
    "match": {
      "productName": {
        "query" : "vegetarian baked beans",
        "minimum_should_match" : 2
      }
    }
  }
}
```

7. Answer the question: "Which products have a productName that includes all of the terms vegetarian baked beans?" 

```
GET products/_search
{
  "query": {
    "match": {
      "productName": {
        "query" : "vegetarian baked beans",
        "minimum_should_match" : 3
      }
    }
  }
}
```

8. Run a match_phrase search for olive oil in the productName field that returns the top 50 hits. 

```
GET products/_search
{
  "size": 50, 
  "query": {
    "match_phrase": {
      "productName": "olive oil"
    }
  }
}
```

9. Run a match_phrase query for "chocolate cookies" on the productName field with a "size" of 200.

GET products/_search
{
  "size": 200, 
  "query": {
    "match_phrase": {
      "productName": "chocolate cookies"
    }
  }
}

In the previous query, notice 5 products had the top score of 9.120971. Why do you think those 5 products scored higher than the next 3 products (which all have the same score of 8.512876). 

Add a slop property of 1 to the previous search and run it again. You should get more hits. 

Scroll down toward the end of the results of your previous search. Notice how the slop property added hits like "chocolate chip cookies" and "chocolate graham cookies".
Change the slop parameter to 2 and run the previous search again. Notice the numbers of hits goes up even more. Scroll down and look at some of the last hits like "Glutino Gluten Free Vanilla Milk Chocolate Coated Wafer Cookies" and "Ginnybakes Fresh Baked Organic Gluten-free Cookies Chocolate Chip Love". How does a product with the terms reversed ("cookies chocolate") become a hit? 

10. Modify the query in the previous step so that it contains a filter that only shows products with a price of less than or equal to 4.00.

```
GET products/_search
{
  "size": 200,
  "query": {
    "bool": {
      "must": [
        {
          "match_phrase": {
            "productName": {
              "query": "chocolate cookies",
              "slop": 2
            }
          }
        }
      ],
      "filter": {
        "range": {
          "price": {
            "lte": 4
          }
        }
      }
    }
  }
}
```

11. OPTIONAL: Suppose you have a customer looking for a healthy yogurt. Write and execute a search that satisfies the following requirements:
	productName must contain "yogurt"
	productName should contain at least one of the terms "original" or "organic", with a boost of 2 given to "organic" items
	The customerRating should be greater than or equal to 4

```
GET products/_search
{
  "size": 50,
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "productName": "yogurt"
          }
        }
      ],
      "should": [
        {
          "match": {
            "productName": "original"
          }
        },
        {
          "match": {
            "productName": {
              "query": "organic",
              "boost": 2
            }
          }
        }
      ],
      "minimum_should_match": 1, 
      "filter": {
        "range": {
          "customerRating": {
            "gte": 4
          }
        }
      }
    }
  }
}
```

# Aggregations

Objective: In this lab, you will perform various metrics and bucket aggregations on the products index and also on some stock market trade data that has the open, high, low, close and volume of the stocks' daily trades.

1. Perform a stats aggregation on the price field of your products dataset. Set the "size" property to 0 so you only get back the aggregation results. 

```
GET products/_search
{
  "size": 0,
  "aggs": {
    "price_stats": {
      "stats": {
        "field": "price"
      }
    }
  }
}
```

2. We have not discussed this yet, but there is a similar statistics aggregation called extended_stats that uses the same syntax as stats. Run an extended_stats aggregation on the price field and compare the output to the stats aggregation in the previous step:

```
GET products/_search
{
  "size": 0,
  "aggs": {
    "price_stats": {
      "extended_stats": {
        "field": "price"
      }
    }
  }
}
```

3. What is the average price of all the products by "Betty Crocker"? Note that "Betty Crocker" is the brandName of a company. (The answer is $14.25) 

```
GET products/_search
{
  "size": 0, 
  "query": {
    "term": {
      "brandName.keyword": {
        "value": "Betty Crocker"
      }
    }
  },
  "aggs": {
    "average_price": {
      "avg": {
        "field": "price"
      }
    }
  }
}
```

4. You are going to use a new dataset for the remainder of this lab that contains stock market trades. Write an aggregation that answers the question: 'How many unique stock symbols are in the stocks index?' (The answer is 524) 

```
GET stocks/_search
{
  "size": 0,
  "aggs": {
    "distinct_symbols": {
      "cardinality": {
        "field": "stock_symbol.keyword"
      }
    }
  }
}
```

5. What is the average high of the "EBAY" stock_symbol? (The answer is $23.56) 

```
GET stocks/_search
{
  "size": 0, 
  "query": {
    "term": {
      "stock_symbol.keyword": {
        "value": "EBAY"
      }
    }
  },
  "aggs": {
    "ebay_avg_high": {
      "avg": {
        "field": "high"
      }
    }
  }
}
```

6. Perform a terms bucket aggregation that puts all the stock documents from each distinct stock_symbol into their own bucket. Set the size parameter to 10. 

```
GET stocks/_search
{
  "size": 0,
  "aggs": {
    "stock_symbol_buckets": {
      "terms": {
        "field": "stock_symbol.keyword",
        "size": 10
      }
    }
  }
}
```

7. Perform an extended_stats aggregation on the close field of each bucket in the previous search. The output should look like:

```
GET stocks/_search
{
  "size": 0,
  "aggs": {
    "stock_symbol_buckets": {
      "terms": {
        "field": "stock_symbol.keyword",
        "size": 524
      },
      "aggs": {
        "close_stats": {
          "extended_stats": {
            "field": "close"
          }
        }
      }
    }
  }
}
```

8. Using a date_range aggregation, find the maximum close price for each distinct stock in the month of January, 2010, and the month of February, 2010. 

```
GET stocks/_search
{
  "size": 0,
  "aggs": {
    "stock_symbol_buckets": {
      "terms": {
        "field": "stock_symbol.keyword",
        "size": 524
      },
      "aggs": {
        "my_date_ranges" : {
          "date_range": {
            "field": "trade_date",
            "ranges": [
              {
                "key": "Jan_2010", 
                "from": "2010-01",
                "to": "2010-02"
              },
              {
                "key": "Feb_2010",
                "from": "2010-02",
                "to" : "2010-03"
              }
            ]
          },
          "aggs": {
            "max_close": {
              "max": {
                "field": "close"
              }
            }
          }
        }
      }
    }
  }
}
```

# SQL 
# We will be using the sample web log data we loaded earlier

```
GET _sql?format=txt
{
  "query": "SELECT COUNT(*) as total_errors, timestamp FROM kibana_sample_data_logs WHERE tags LIKE '%error%' GROUP BY timestamp ORDER BY timestamp DESC"
}
GET _sql?format=csv
{
  "query": "SELECT SUM(bytes) as total_bytes, host FROM kibana_sample_data_logs GROUP BY host"
}
```
# Convert SQL to query DSL

```
GET _sql/translate
{
  "query": "SELECT COUNT(*) as total_errors FROM kibana_sample_data_logs WHERE tags LIKE '%warning%' OR tags LIKE '%error%'"
}
```
