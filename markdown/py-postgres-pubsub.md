## Real-time updates to a web-app using only Python and Postgres

### Requirements

- Rest API - to handle basic CRUD (create, update, delete items)
- Websockets - streams over which, when something changes we can get events with all the information that the UI needs to update itself
- Front-end 

### Postgres 

- has *pub-sub* built in, using commands
  - `LISTEN` - to receive updates happening on a channel, and
  - `NOTIFY ` - to send a message on a channel
    Alternatively, use the `pg_notify()` function
  - Note that payload sizes are limited to 8k bytes. 
- has *json* features built-in, for ex. the `row_to_json()` function
- has *triggers* - defining a function and attaching it to CRUD operations

### Python and Postgres

- Create a Python process to listen to a postgres channel (called 'test' here)

```python
# Subscribe to the Postgres pubsub channel

import select
import psycopg2

conn = psycopg2.connect(user='pypg_user', database='pubsub')
conn.autocommit = True # Enable transaction support

cur = conn.cursor()
cur.execute('LISTEN test;');

while True:
  if select.select([conn], [], [], 5) != ([], [], []):
    conn.poll()
    while conn.notifies:
      notify = conn.notifies.pop(0)
      print notify.payload
```

or, alternatively,

```python
# pypglisten.py
# 

import pgpubsub

pubsub_1 = pgpubsub.connect(user='dkhosla', 
                          database='default')

pubsub_1.listen('test');

for e in pubsub_1.events():
  print e.payload
```

- Then, from the PSQL prompt, execute a `NOTIFY` command

```sql
psql=# NOTIFY test, 'Hello Python!';
```

### REST APIs

These turn CRUD operations into straightforward `method` calls to endpoints. Consider for example the tasks in a to-do app;

| Action         | Request                 |
| -------------- | ----------------------- |
| Create an item | POST /api/todos/        |
| List all items | GET /api/todos/         |
| List one item  | GET /api/todos/<id>/    |
| Update an item | PUT /api/todos/<id>/    |
| Delete an item | DELETE /api/todos/<id>/ |

To stream changes to an item, we'd have to use `WebSocket`s

### Web Application

