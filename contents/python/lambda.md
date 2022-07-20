
## LAMBDA FUNCTION

Generate requirements.txt for a project : `pipreqs /path/to/project`

To make small dependency list for lambda function try the following:

```bash
# create virtual environment
python3 -m venv .venv
# pip install existing libraries
pip3 install -r requirements.txt
# filter out boto3 and botocore if they were accidentally included as part of dependencies 
pip3 freeze | grep -Ev 'boto3|botocore' > requirements.txt
# In the future, if we want to create a vendored file using pip3 install, just run with --no-deps
pip3 install -t vendored/ -r requirements.txt --no-deps
# 
```

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