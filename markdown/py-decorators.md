# Decorators
#advanced-python/decorators

We know that Python functions are **first-class objects** that can be passed around like objects of any other type.  Functions, without the parenthesis, can be passed to or returned from other functions. 

> By definition, a decorator is a function that takes another function and extends the behavior of the latter function (decorates it) without modifying it.  

So, a decorator is simply a wrapper around an existing function. This feature is extremely helpful if you want to extend the functionality of a module without modifying the source functions! Note that inner functions (the `wrapper`) have read access to the enclosing scope of the decorator, commonly called a `closure`.  

## Syntax
We wrap a function in a `decorator` by pre-pending the function definition with a decorator name and the `@` symbol. As an example:

```python
# declare the decorator
def my_decorator(func_01):
	"""
	"""
	def my_wrapper():
		"""
		"""
		...
		func_01()
		...
		return None
	return my_wrapper

# use the decorator
@my_decorator
def my_function():
	"""
	"""
	...
	return None

# Note; This is the same as writing
my_function = my_decorator(my_function)
```


### Multiple Decorators

If you have multiple decorators that you want to apply to a function, you can write

```python
# using multiple decorators
@decorator_01
@decorator_02
@decorator_03
def function_01():
	"""
	"""
	...
	return None

# this is the same as writing
function_01 = decorator_01(decorator_02(decorator_03(function_01)))
```


## References
- [The Code Ship](https://www.thecodeship.com/patterns/guide-to-python-function-decorators/)
- 