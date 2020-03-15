To be updated

### Drop to python interactive console in middle of code

The usual pdb

```
import pdb; pdb.set_trace()
```

Dropping into ipython

```
import IPython;IPython.embed()
```

### Converting time example

```python
a = "2019-10-02T04:20:32.15Z"
t = time.strptime(a,"%Y-%m-%dT%H:%M:%S.%fZ") 
```

### Subtracting time

