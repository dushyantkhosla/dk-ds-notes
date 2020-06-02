# DS Coding Narrative

- Software engineering practices for data scientists:
  - Write modular, re-usable code
  - Write documentation 
  - Version control
  - Testing
  - Logging

## 1. Porting .ipynb to .py (Build step)

- Some more best practices:
  - Notebook should be **linearized**, 
    Executing *Restart and run all* is a good way to check for this linearity.
  - Save the result for reproducibility using Git based solution
  - Don't accidentally commit the raw data. 
    Add the data file or folder in the .gitignore file
  - Keep re-usable functions in packages
  - In python make a package by creating a `__init__.py` file in the folder, 
    this makes the data and functions in the file importable.
  - Create a new file in this importable folder, put the concerned function in the file create proper documentation for the function.
    ​

- **Example:**
  `iris-dev/notebooks/01-Obtain.ipynb` to `iris-dev/src/obtain/obtain.py`
  ​

- **Write modular, re-usable code**- 
  Don't Repeat Yourself. The basic idea is that many tasks can be abstracted into a function or piece of code that can be reused regardless of the specific task. 
- Modules allow us to separate code into parts that hold related data and functionality.
 * Modules can be either built-in (such as *os* and *sys* ), third-party apps installed in your environment 
  (such as *NumPy*) or your project's internal modules.
* There are multiple ways to import modules

`>>> import sys # built-in module`  
`>>> import matplotlib.pyplot as plt # 3rd party module`   
`>>> import mymodule #internal project module`

* To adhere to the style guide, keep module names short and lowercase
  and avoid using special symbols like dot(.) or question mark(?)

* First, the `import modu `statement will look for the definition of modu in a file named modu.py in the same directory as  the caller if a file with that name exists. If it is not found, the Python interpreter will search for modu.py in Python’s search path recursively and raise an ImportError exception if it is not found. The value of the search path is platform-dependent 
  and includes any user- or system-defined directories in the environment’s $PYTHONPATH 

* Once modu.py is found, the Python interpreter will execute the module in an isolated scope. Any top-level statement in modu.py will be executed, including other imports, if any exist. Function and class definitions are stored in the module’s dictionary.
  Finally, the module’s variables, functions, and classes will be available to the caller through the module’s namespace.

* Namespaces provide a scope containing named attributes that are visible to each other but not directly accessible outside
  of the namespace.

* The result of the `import modu` statement will be a module object named *modu* in the global namespace, with the
  For example, attributes defined in the module accessible via dot notation: `modu.sqrt`would be the `sqrt `object defined inside of modu.py

* Another way of importing modules
  `from modu import *` is generally bad practice, it makes code harder to read and makes dependencies less compartmentalized. and can overwrite existing defined objects with the new definitions inside the imported module.

## 2. Tests (Build step)
- Type of testing for Data Scientists
  - Unit testing
  - Regression testing
  - Integration testing
- When to test
  - Extract
  - Transform
  - Model 
  - Load
- TDD —> Test, Code, Refactor
- Test the code, not the implementation
- When you find a bug, add a test
- When you change code, add a test
- Exploratory data analysis is an example of when TDD doesn’t really make sense,.WHY? Because “testing” implies that there is a correct answer to the thing you are testing, which is not the case in the exploration phase.
- So, when we talk about testing in data science, we are targeting quality control.
- There are two common use cases for testing in data science work:
  - When someone changes code and wants to merge it into main branch, how will we ensure that they have not introduced errors?
  - When deploying code to production
    - We can check stability of data -  Seam testing Data will flow into a machine learning algorithm and flow out of the algorithm. We can test those two seams by unit testing our data inputs and outputs to make sure they are valid within our given tolerances.
    - Schema checks: Making sure that only the columns that are expected are provided.
    - Data checks:Looking for missing values, Ensuring that expected value ranges are correct

- For writing tests, unit test framework like PyTest, unittest, nosetest can be used
- Make a directory tests/  in src folder and drop the test files in there
- If we use `pytest` package for testing, we can run all files of the form test_*.py or *_test.py in the current directory and its subdirectories,
   by command `python -m pytest <foldername>`
- We can start by writing simple tests, which check schema and data sanity checks:
```
import src.obtain as ob

class TestObtain:

    @classmethod
    def setup_class(cls):
        cls.iris_df = ob.get_raw_data()

    def test_shape(self):
        assert self.iris_df.shape == (150, 5)

    def test_classes(self):
        assert self.iris_df['iris_type'].nunique() == 3

```
- It also shows how much time your test took, it gives an indicator for 
  code improvement.
```
  python -m pytest .
================================= test session starts ==================================
platform darwin -- Python 3.6.0, pytest-3.4.1, py-1.5.2, pluggy-0.6.0
rootdir: /Users/nsingh/Workspace/iris-dev, inifile:
collected 2 items

tests/test_obtain.py ..                                                          [100%]

============================== 2 passed in 10.71 seconds ===============================
```

## 3.Docker deploy (Ship step)
- API First Approach
- Exposing the model using Flask
- Explain contents of __app.py__
- Ship —> Model + app.py 

- Example Dockerfile for deployment
```
...
# Install app dependencies
RUN pip install Flask

# Bundle app source
COPY app.py /src/app.py
COPY models /models/

EXPOSE  5000
CMD ["python", "/src/app.py", "-p 5000"]
```

- API path : http://dopfracalmina01.node.pmids.ocean:5000/api
  API raw (JSON) args:
```
{
"sl":3,
"sw":5,
"pl":3.75,
"pw":2.1,
"algo":"dt"
}
Result Body:
{
    "iris_type": "versicolor",
    "model": "dt"
}
```


## 4.Python packaging (Ship Step)
- Bundling your code as package is necessary, when you have functionality which can be re-used across different projects.
- The following structure is all that’s necessary to create reusable simple packages with no ‘packaging bugs’. 
    - First, ensure that our directory structure should look like
    ```
    iris-dev/
        src/
            __init__.py
    setup.py
    ```

    - The main setup config file, `setup.py`, should contain a single call to `setuptools.setup()`, like so:
    ```
    setup(
    name='iris-dev',
    version='0.1.0',
    description='Training template based on iris dataset',
    long_description=readme,
    author='John Doe',
    author_email='author@example.com',
    url='https://example.com',
    license=license,
    packages=find_packages(exclude=('tests', 'docs')))
    ```
    - Create a source distribution with: `python setup.py sdist`, this will create dist/iris-dev-0.1.tar.gz inside our 
      top-level directory.
    - At this point, your python package is ready for internal distribution and other users can install the package with
       `pip`.
    - Additional note: You can also integrate test runs into your setuptools based project with the pytest-runner plugin.
      Add this to setup.py file:

    ```from setuptools import setup
    setup(
        #...,
        setup_requires=['pytest-runner', ...],
        tests_require=['pytest', ...],
        #...,
    )
    ```

   - And create an alias into setup.cfg file:
    ​```
    [aliases]
    test=pytest
    ​```
   - If you now type:
    `python setup.py test` this will execute your tests using pytest-runner.