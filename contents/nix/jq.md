When running jq, the following arguments may become handy:

| Argument        |  Description  |
| ----------------| :------------:|
| `--sort-keys`   | Output the fields of each object with the keys in sorted order.|

## Basic concepts

The syntax for jq is pretty coherent:

| Syntax  |  Description  |
| --------| :------------:|
|    ,    | Filters separated by a comma will produce multiple independent outputs|
|    ?    | Will ignores error if the type is unexpected |
|    []   | Array construction |
|    {}   | Object construction |
|    +    | Concatenate or Add |
|    -    | Difference of sets or Substract |
|   "|"   | Pipes are used to chain commands in a similar fashion than bash|
|  length | Size of selected element |


## Dealing with json objects

| Description                | Command |
| ---------------------------| :-----: |
| Display all keys           | `jq 'keys'` |
| Adds + 1 to all items      | `jq 'map_values(.+1)'` |
| Delete a key               | `jq 'del(.foo)'` |
| Convert an object to array | `to_entries | map([.key, .value])` |

## Dealing with fields

| Description           | Command |
| ----------------------| :-----: |
| Concatenate two fields| `fieldNew=.field1+' '+.field2` |


## Dealing with json arrays

### Slicing and Filtering

| Description                        | Command |
| -----------------------------------| :-----: |
| All                                | `jq .[]` |
| First                              |	`jq '.[0]'` |
| Range                              | `jq '.[2:4]'` |
| First 3                            | `jq '.[:3]'` |
| Last 2                             | `jq '.[-2:]'` |
| Before Last                        | `jq '.[-2]'`|
| Select array of int by value       | `jq 'map(select(. >= 2))'` |
| Select array of objects by value   | ** jq '.[] | select(.id == "second")'** |
| Select by type                     | ** jq '.[] | numbers' ** with type been arrays, objects, iterables, booleans, numbers, normals, finites, strings, nulls, values, scalars |

### Mapping and Transforming

| Description                          | Command |
| -------------------------------------| :-----: |
| Add + 1 to all items                 | `jq 'map(.+1)'` |
| Delete 2 items                       | `jq 'del(.[1, 2])'` |
| Concatenate arrays                   | `jq 'add'` |
| Flatten an array                     | `jq 'flatten'` |
| Create a range of numbers            | `jq '[range(2;4)]'` |
| Display the type of each item        | `jq 'map(type)'` |
| Sort an array of basic type          | `jq 'sort'` |
| Sort an array of objects             | `jq 'sort_by(.foo)'` |
| Group by a key - opposite to flatten | `jq 'group_by(.foo)'` |
| Minimun value of an array            | `jq 'min'` .See also  min, max, min_by(path_exp), max_by(path_exp) |
| Remove duplicates                    | `jq 'unique'` or `jq 'unique_by(.foo)'` or `jq 'unique_by(length)'` |
| Reverse an array                     | `jq 'reverse'` |

### Tips

__WTF:__ When using jq with piping in terminal, any version below jq 1.6 will end up showing help menu for JQ

jq can also be used to insert/modify values inside a json 

```bash
cat Preference.json  |\
  jq '.session.restore_on_startup=4' |\
  jq '.session.startup_urls=["https://ebfe.pw"]'
```

Elaborate example:

```bash
[
    {
        "nodes":[ 0,2],
        "nodetype":"Alpha",
        "bool4": true,
        "dict":{"a":1, "b":2}
    },
    {
        "nodes":[ 1,3],
        "nodetype":"Beta",
        "bool4": true,
        "dict":{"a":1, "b":2}
    },
]
```

Fun:
 - Convert current array -> new array, use nodes[] as index to assign values in new array
 - convert to {key,value} dictionary using to_entries
 - slicing the new array
 - reconstruct new array again into another array of dictionaries with Name constructed from NodeType and its index.(Alpha-1,Beta-2 and so on)
 

```bash
jq ' reduce .[] as $k ([]; .[$k.nodes[]] = ($k|{nodetype,dict,bool4})) 
   | to_entries 
   | .[] 
   | reduce .[] as $k ([]; .[$k.key] = {name:"\($k.value.nodetype)-\($k.key)",dict:$k.value.dict})'  
```
