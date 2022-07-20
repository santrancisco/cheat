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
### Tips

Upgrading to full tty from dodgy shell

```
python -c 'import pty; pty.spawn("/bin/bash")'
```

Run simple http server in port 8889
```
python2.7 -m SimpleHTTPServer 8889
python3 -m http.server 8889
```

Simple `__str__` function for development to print and debug objects

```python
def __str__(self):
  return json.dumps(self.__dict__, indent=2, separators=(',', ': '))
```
Generate requirements.txt for a project : `pipreqs /path/to/project`