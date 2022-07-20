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
*Explanation:*

1 - Look in `index main` for items with LogType="`LoginInfo`"  
AND

[ 

Search index `firewall` for `firewal_block_event`, `deduplicate` ip addresses, rename that field to `IpAddress` to match with what we have in main `index` above, then only extract this fields to `format` into a search query. This magic command (format) spit out a search query similar to ((IpAddress="1.1.1.1") OR (IpAddress="2.2.2.2")) and so on to be used by this query. 

]

with the result (User Login + ip is in the list of flagged ip from firewall index), we construct the AppURL and FirewallTrafficURL field to get the URL for these apps ready for alert notifcation.

We then `de-duplicate` AppURL URL to make sure we get unique ones

We run `iplocation` plugin and just incase it collide with some of the fields in main index, we `prefix` ALLFIELDS it with `iploc_` 

Finally we extract and count only interesting fields.

---

*Another powerful combine search:*

```Javascript
[ search sourcetype="vpnlog" 
    | search 
        [ search sourcetype="useraction" AccountID=12345
            | search userid="Admin-*" 
            | eval adminuser=trim(replace(userid, "Admin-", "")) 
            | eval user="DOMAIN\\"+adminuser 
            | dedup user 
            | table user 
            | format 
        ] 
    | dedup src_ip 
    | rename src_ip AS IpAddress 
    | table user,IpAddress
]  
| outputlookup AdminIPs.csv
```

3 nested search: 
 - Search the useraction log for user actions start with "Admin-"
 - Process the log and extract the admin username, adding "DOMAIN\" infront so we can search vpn log for it
 - Extract VPN logs for admin user and their log in IPs


```Javascript
sourcetype="useractions" 
| search AccountID=12345
| iplocation IpAddress 
| join type=left IpAddress 
    [ !inputlookup AdminIPs.csv
    ]
| rename user as AdminActOnBehalf
| table TimeStamp, IpAddress, Country, userid, Action, AdminActOnBehalf
```

Now, going back to original sourcetype - useractions, we are looking for any row with Administrator IP Address and replace it with Admin's IP addresses. 

*Note: All search fields have been modified from original queries*


*A fucking big search*


```Javascript
sourcetype=nginx earliest=-10m 
    [ search index=firewall earliest=-30m 
    | search "tags{}.type"="maybemalicious" 
    | rename remoteIP as remoteaddr 
    | dedup remoteaddr 
    | table remoteaddr 
    | format] 
| search uri=*EditorURI* 
| dedup uri 
| eval uri = trim(replace(uri, "POST ", "")) 
| eval uri = trim(replace(uri, "GET ", "")) 
| rex field=_raw "\+0000] (?<realhostname>[a-zA-Z0-9\.]*) " 
| eval FinalURL = "https://"+realhostname+URI 
| search FinalURL=* NOT 
    [| inputlookup previousurls.csv 
    | fields FinalURL 
    | format ] 
| appendpipe 
    [| table FinalURL 
    | dedup FinalURL 
    | outputlookup append=t previousurls.csv
        ] 
| rename remoteaddr as IpAddress 
| join type=left IpAddress 
    [ search index=main AND sourcetype=authlog AND Event=Login earliest=-1h] 
| eval "Output"=if(isnull(userid),$FinalURL$+"-Null-"+IpAddress,$FinalURL$+"-"+userid+"-"+IpAddress) 
| table Output 
| stats list(Output) as Output 
| eval Output=mvjoin(Output, ",")
```

*Explanation:*
 - Search firewall log for IP addresses that was flaged potentially malicious
 - Search nginx log for those Ips and look for Editor URI so we can construct an URL to view this data being edited live 
 - Due to some nginx parsing rule error, we may need to do some fancy magic regex to get the realhostname
 - Construct the final URL
 - Filter on only NEW urls because you may run this alert would be trigger periodically and can alert on same data over and over when user takes too long to edit.
 - Any new urls, append it to the previousurls.csv lookup table
 - rename remoteaddr to match with authlog index
 - search authlog index and join Editor nginx event with the login event from db to know which userid this nginx event belong to
 - Export this to parsable format by some sort of lambda function/ webhook downstream


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


### Debugs

List all index and source-type:
- Summary  : `| tstats values(sourcetype) where index=* group by index`
- More info: `index=_internal source=*license_usage.log | table idx,st,s,h,_raw | dedup idx,st`

Search splunkd internal log for error: `index=_internal sourcetype=splunkd "error"`

### localsplunk for the win

To run our own local splunk:

```bash
docker run -d -p 8000:8000 -e "SPLUNK_START_ARGS=--accept-license" -e "SPLUNK_PASSWORD=$SPLUNKPASS" --name splunk splunk/splunk:latest
```

To quickly add data for analysis is as simple as going to "Settings" -> Add Data -> File Upload