### Create table
Create athena table for alb log in S3 bucket, partitioned by year, month and date

```sql
CREATE EXTERNAL TABLE IF NOT EXISTS alb_logs (
         type string,
         time string,
         elb string,
         client_ip string,
         client_port int,
         target_ip string,
         target_port int,
         request_processing_time double,
         target_processing_time double,
         response_processing_time double,
         elb_status_code string,
         target_status_code string,
         received_bytes bigint,
         sent_bytes bigint,
         request_verb string,
         request_url string,
         request_proto string,
         user_agent string,
         ssl_cipher string,
         ssl_protocol string,
         target_group_arn string,
         trace_id string,
         domain_name string,
         chosen_cert_arn string,
         matched_rule_priority string,
         request_creation_time string,
         actions_executed string,
         redirect_url string,
         lambda_error_reason string,
         target_port_list string,
         target_status_code_list string,
         new_field string 
) 
PARTITIONED BY ( 
  `year` string, 
  `month` string, 
  `day` string) -- This is how the folder under bucket is structure.. /{region}/year/month/day
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
         'serialization.format' = '1', 'input.regex' = '([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*)[:-]([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-.0-9]*) (|[-0-9]*) (-|[-0-9]*) ([-0-9]*) ([-0-9]*) \"([^ ]*) ([^ ]*) (- |[^ ]*)\" \"([^\"]*)\" ([A-Z0-9-]+) ([A-Za-z0-9.-]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\" ([-.0-9]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^ ]*)\" \"([^\s]+?)\" \"([^\s]+)\"(.*)')
LOCATION 's3://s3bucket-alb-logs/S3pathTo/AWSLogs/{AccountID}}/elasticloadbalancing/{region}}';
```

### Examples
An example of complicated Athena query to search for clients use old TLS, go through api calls, perform some regex/split to obtain the GUID and also create a temporary lookup table for later use.

```sql
WITH temptable AS (

SELECT COUNT(ssl_cipher) AS count,
   ssl_protocol,
   request_url,
   user_agent,
   url_extract_path(request_url) as path,
   element_at(split(regexp_extract(url_extract_path(request_url), '(api\/)(create\/(p|P)ost|list/(p|P)ost)\/((\w+\-){4}\w+)'), '/'), -1) as animportant_GUID
         
FROM alb_logs_2019_07

GROUP BY ssl_protocol, request_url, user_agent

HAVING ssl_protocol != 'TLSv1.2'
  AND ssl_protocol != '-'
  AND url_extract_path(request_url) != '/api/ignorethispath' -- excluded, there are no UUIDs or any IDs in this request path

ORDER BY COUNT DESC)

SELECT count,
   ssl_protocol,
   request_url,
   user_agent,
   path,
   path_last
FROM temp
WHERE count >= 10
```