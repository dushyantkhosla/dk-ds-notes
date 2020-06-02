# Unit Testing with pytest
#reproducible-research/unit-testing

Tests are just simple functions named `test_whatever()` and for each condition we want to test, we just write simple `assert` statements. 

### How it works

The  `py.test` command issue on the command-line in your project folder walks through your files, looking for **test modules** (files named `test_*.py`) and **test functions** (`def test_*()`). Read more about these conventions [here](http://doc.pytest.org/en/latest/goodpractices.html#test-discovery).

When a test fails, `pytest` highlights the line where the test failed and displays the input values of that `assert` statement. Note that the `-q`  (for *quiet*) flag suppresses overly verbose output.

More complicated tests involve checking against a few different *scenarios* (different combinations of inputs, maybe some *edge cases*.) This is where [Parameterized Test Functions](http://doc.pytest.org/en/latest/parametrize.html#pytest-mark-parametrize-parametrizing-test-functions) help us save keystrokes by using `decorators` to do something special. We specify a list of arguments to be passed to the test function; the test function will then be run once for each set of parameters.