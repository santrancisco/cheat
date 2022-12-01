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

To make AWS lambda fuction look for library inside a ./vendored folder, we can add this at the beginning of main lambdafunction handler code

```python
import os
import sys

# if running in lambda, add the vendored folder to python path
if 'LAMBDA_TASK_ROOT' in os.environ:
  sys.path.append(f"{os.environ['LAMBDA_TASK_ROOT']}/vendored")

# this will render all of packages placed as subdirs available
sys.path.append(os.path.dirname(os.path.realpath(__file__)))
```



### Decluster virtualenv

There is no easy way to manage virtualenv for python - creating it inside/beside your application can be a pain as it may get included into your git commits  etc... 
Here is a bash function that could help decluster:

```bash
function createvirtualenv() {
  mkdir -p ~/.pythonvirtualenv/`pwd`
  pushd ~/.pythonvirtualenv/`pwd`
  virtualenv virtualenv
  popd
  source ~/.pythonvirtualenv/`pwd`/virtualenv/bin/activate
}

function loadvirtualenv {
  source  ~/.pythonvirtualenv/`pwd`/virtualenv/bin/activate
}
```