- **Asynchronous Processing?**
  - Synchronous operations are all executed within the main process.  Every line of code, regardless of the duration it takes to execute, will be processed in a sequential manner from top to bottom.
  - Asynchronous task queues allow pieces of a program to run in a separate process.
  - Use cases 
    - delegate long lasting CPU jobs
    - execute external API calls. 
  - Asynchronous processing helps us reduce the user wait time and improve responsiveness.
    - isolate time consuming parts of code into functions
    - run these separately from the main process

- **What is Celery**
  - distributed system to process vast amounts of messages
  - uses an asynchronous task queue
  - focused on real-time operation, but supports scheduling as well
  - Simply put: Celery has an input and an output. 
    The input must be connected to a broker, and 
    the output can be optionally connected to a result backend.
- **Celery Tasks** are executed
  - concurrently (on a single or more worker servers) using multiprocessing
  - asynchronously (in the background) or synchronously (wait until ready).
- Services used frequently with Celery
  - message broker like *redis* or *RabbitMQ*
  - *Flower* as a web-admin for real-time monitoring for Celery
- **Dependencies**

```bash
sudo apt-get install rabbitmq-server
# http://www.rabbitmq.com/download.html

pip install celery
```

- **Basic Celery Application**
  - The first argument to `Celery` is the name of the current module.
  - tasks are defined in the `__main__` module.

```python
# celery.py
from celery import Celery
app = Celery('proj', 
             broker='ampq://',
             backend='ampq://',
             include=['proj.tasks'])

app.conf.update(...)

if __name__ == '__main__':
    app.start()
    
# tasks.py
@app.task
def add(x, y):
    return x + y

@app.task
def mult(x, y):
    return x * y
```

- **Running Celery**
  - Issue this command in the directory containing `proj/`

```bash
celery -A tasks worker --loglevel=info

## See
# celery help
# celery worker --help
```

- **Calling Tasks**
  - use the `.delay()` method
  - `delay` places the task in the queue and returns a promise that can be used to monitor the status and get the result when it's ready

```python
>>> from tasks import add
>>> add.delay(1, 2)
```

- Note
  - Calling a task returns an [`AsyncResult`](http://docs.celeryproject.org/en/latest/reference/celery.result.html#celery.result.AsyncResult) instance. 
    This can be used to check the state of the task, wait for the task to finish, or get its return value (or if the task failed, to get the exception and traceback).
  - Results are not enabled by default. 
    In order to do remote procedure calls or keep track of task results in a database, you will need to configure Celery to use a result backend.

- **Results Backend**
  - Possible choices - SQLAlchemy, Redis, RMQ
  - The backend is specified via the `backend` argument

```python
# tasks.py 
app = Celery('tasks', backend='redis://localhost', broker='pyamqp://')

# --------

>>> result = add.delay(1, 2)

>>> result.ready() 
# returns whether the task has finished processing or not

>>> result.get(timeout=1)
3

>>> result.traceback
# If the task raised an exception, get access to the original traceback
```

- **Warning!**
  - Backends use resources to store and transmit results. To ensure that resources are released, you must eventually call [`get()`](http://docs.celeryproject.org/en/latest/reference/celery.result.html#celery.result.AsyncResult.get) or [`forget()`](http://docs.celeryproject.org/en/latest/reference/celery.result.html#celery.result.AsyncResult.forget) on EVERY [`AsyncResult`](http://docs.celeryproject.org/en/latest/reference/celery.result.html#celery.result.AsyncResult) instance returned after calling a task.
- **Configurations**
  - Can be done in the app script

```python
app.conf.update(
    task_serializer='json',
    accept_content=['json'],  # Ignore other content
    result_serializer='json',
    timezone='Europe/Oslo',
    enable_utc=True,
)
```

- Centralized Configuration
  - a dedicated `celeryconfig.py` module is recommended over hard-coding options
  - `task_routes` can be used to send a misbehaving task to a dedicated queue
  - `task_annotations` can be used to rate limit the task instead

```python
# celeryconfig.py
broker_url = 'pyamqp://'
result_backend = 'rpc://'

task_serializer = 'json'
result_serializer = 'json'
accept_content = ['json']
timezone = 'Europe/Oslo'
enable_utc = True

task_routes = {
    'tasks.add': 'low-priority'
}

task_annotations = {
    'tasks.add': {'rate_limit': '10/m'}
}

# tasks.py
app.config_from_object('celeryconfig')
```

- In Production
  - Run the worker in the background via daemonization
  - the `celery mutli` command is used to start workers in the background