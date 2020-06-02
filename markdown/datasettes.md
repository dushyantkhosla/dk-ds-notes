## Datasettes

Web-based Python tool for exploring data in a sqlite db. 
See [datasette.io](datasette.io)

**Features**

- Creates a web-server that allows user to quickly inspect, filter, sort tables
- Write SQL queries
- If the data has latitude/longitude columns, 
  get a map for free with the `datasette-cluster-map` module
- Publish data and share with collarborators with `datasette publish` (in development)

**Usage**

```python
# pip install datasette datasette-cluster-map

datasette -p 8085 "Users/dkhosla/path-to-some/sqlite.db"
```

**Also see**

- [glitch.com](glitch.com) for a JSFiddle-like environment for Python