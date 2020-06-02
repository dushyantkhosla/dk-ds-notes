# Flask

---

## 1. Clients, Requests, Servers, Applications, Routes, Views and Responses 

- When a user *requests* a URL on the web, the *client* (his web browser) sends a request to the web *server*, which then forwards the request to the app. 
- The app maintains a mapping of URLs to *view* functions (called *routes*), defined using the `@app.route(URL)` decorator. 
- The server then forwards the output of the particular view function (the *response*) to the client.

- An Example

```python
import flask as Flask

# ----- Create an instance of the application (of type Flask) -----
app = Flask(__name__)

# ----- Write view functions and register them as routes -----
@app.route('/')
def index():
    return "<h1>Welcome!</h1>"

@app.route('/user/<name>')
def user_profile(name):
    return f"<h1>Hello {name}!</h1>"

# ----- Start Flask's intergrated development web server -----
if __name__ == '__main__':
    app.run(debug=True)
    
# ----- The server goes into a loop that listens for requests and services them ------    
```

- Use `app.url_map` to list the mapping of URL to view functions.
- A `methods` argument has to be added to the `@app.route` decorator to tell Flask to register the view function as a handler for both `GET` and `POST` requests in the URL map. The default action is to be `GET` only.



## 2. Contexts, Hooks, Responses, Redirects

### Contexts

- Flask uses *contexts* to make objects (such as the HTTP request received from a client) available to all view 
- These are of two types - **application** and **request**
- the *application* context exposes variables 
  - `current_app` (the application instance) and 
  - `g` (used for temporary storage during handling of a request)
- the *request* context exposes variables 
  - `request` (encapsulates the HTTP request from the client), and 
  - `session` (a dictionary to store user data between requests)
-  If any of these variables are accessed without an active application or request context, an error is generated.

```python
from flask import current_app

# ----- Obtain the App Context -----
app_ctx = app.app_context()
app_ctx.push()

# ----- Access the current_app variable -----
current_app.name
```



### Hooks

Hooks are used to implement routines commonly invoked before/after most view functions, such as user authentication or database connections. There are four types of hooks, used as decorator to register functions to be

- `before_first_request`
- `before_request`, run before *each* request
- `after_request`, run *after* each request if no exceptions occur
- `teardown_request`, run after each request regardless of exceptions

The `g` context global variable is commonly used to share data between hooks and views. For example, a `before_request` handler can load the logged-
in user from the database and store it in `g.user` Later, when the view function is invoked, it can access the user from there.

### `make_response()`

When invoked, the *view functions* respond to a request with

- a Python string that represents an HTML page
- the HTTP *status code*, set to `200` (a.k.a success) by default 
- a dictionary of headers (seldom used)

These could be wrapped in a tuple or, in a `Response` object constructed with the `make_response()` function.

```python
@app.route('/') 
def index():
	response = make_response('<h1>This document carries a cookie!</h1>')
    response.set_cookie('answer', '42')
    return response
```



### `redirect()`

- gives the browser a new URL from which to load a new page
- commonly used with web forms
- typically indicated with a `302` response status code
- Flask provides a `redirect()` helper function to create this special response, used in conjugation with `url_for()`

###  `abort()`

- used for error handling
- responds with the `404` status code
- Note that abort does not return control back to the function that calls it but gives control back to the web server by raising an exception.

```python
from flask import abort

@app.route('/user/<id>') 
def get_user(id):
	user = load_user(id) 
    if not user:
        abort(404)
	return '<h1>Hello, %s</h1>' % user.name
```



---

## Ch 4. Forms

### `app.config['SECRET_KEY']`

- data submitted by the user is available via `request.form`
- we use `flask-wtf` to ensure the authenticity of requests 
  - an *encryption key* is used to generate *tokens* for each request
  - we store the key inside the `app.config` dict
  - this key is used by other extensions too

```python
pip install flask-wtf

app = Flask(__name__)
app.config['SECRET_KEY'] = 'ke#!PP9mn&'
```



### The `Form` Class, Fields and Validators

- *Forms* are constructed by extending the base `Form` class
- All *Fields* on the form are listed here, each represented by an object with *validators* attached (functions that check if the input is correct)

```python
from flask.ext.wtf import Form
from wtforms import StringField, SubmitField
from wtforms.validators import Required

class Name(Form):
    name = StringField("First Name", validators=[Required()])                      
    submit = SubmitField("Submit")
```

- `StringField` represents an `<input>` element with `type="text"` attribute, while `SubmitField` has the `type="submit"` attribute.





















