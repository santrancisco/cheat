### Index Time

Sometimes we have logs that takes time to get ingested. When building an alert base off these logs, you may want to use index time instead of event time.
This search is example when you want to "search for `successful` login from `loginlog` sourcetype where Ip address is included in the list of `blocked` IPs indexed in the last `120 minutes`." - Useful when we want to expand the search and see if the blocked ip managed to bruteforce their way into legit account previously.

```Javascript
sourcetype="loginlog" [ 
    search "blocked" _index_earliest=-120m@m _index_latest=-1m@m  | 
    stats count by ip | 
    fields message.ip | format 
    ] | 
spath | search "result"="successful"
```

### Powerful search
A powerful splunk search with lots of tricks:

```Javascript
index=main sourcetype=databaseconnector LogType=LoginInfo 
    [ search index=firewall eventtype=firewal_block_event 
    | dedup "msg.ip" 
    | rename "msg.ip" as IpAddress 
    | fields IpAddress 
    | format] 
| eval "AppURL" = "https://internaltools.com/customer"+$customerid$+"/"+$userid$ 
| eval "FirewallTrafficURL" = "https://firewall.net/company/requests?q=from%3A-1h+ip%3A"+$IpAddress$
| dedup AccessReview 
| iplocation prefix=iploc_ allfields=true IpAddress 
| stats count by AppURL, ActionBy, IpAddress, iploc_Country, FirewallTrafficURL
```
Explanation:

1 - Look in `index main` for items with LogType="`LoginInfo`"  
AND

[ 

Search index `firewall` for `firewal_block_event`, `deduplicate` ip addresses, rename that field to `IpAddress` to match with what we have in main `index` above, then only extract this fields to `format` into a search query. This magic command (format) spit out a search query similar to ((IpAddress="1.1.1.1") OR (IpAddress="2.2.2.2")) and so on to be used by this query. 

]

with the result (User Login + ip is in the list of flagged ip from firewall index), we construct the AppURL and FirewallTrafficURL field to get the URL for these apps ready for alert notifcation.

We then `de-duplicate` AppURL URL to make sure we get unique ones

We run `iplocation` plugin and just incase it collide with some of the fields in main index, we `prefix` ALLFIELDS it with `iploc_` 

Finally we extract and count only interesting fields.


*Note: All search fields have been modified from original queries*

### Complicated fields:

**Calculated fields** let you transform/convert a field to a new field whether by lookup or add/substract from it.

Below is how you could map numerical id to a character id base on the id coming in from log.

```
{sourcetype} : EVAL-charid	| charid	| case(genderid=1,"a",genderid=2,"b",genderid=3,"c",genderid=4,"d",genderid=5,"e",genderid=6,"f",genderid=7,"g")
```

**Field extractions** is particular useful to pull exact information out of log either via custom delimeter or regex.  
Eg below is a silly example to pull "PetName" field from a string in the log.
```
The name of your pet is (?<PetName>.*).
```

Put it together, we can - for example this is to find Pet with name less than 3 characters and reconstruct a seriouslyrandompetshop.com url with the calculated field genderid , petid.

```
index=main sourcetype=pet PetName="*" | eval namelength=len(PetName) | eval "ReconstructedURL"="https://seriouslyrandompetshop.com"+$genderid$+"/"+$petid$ |table ReconstructedURL namelength |  where namelength<4 | dedup ReconstructedURL

```

Or just ask Yohann for help.