[TOC]

# Quick Reference for awk


## Basic Syntax

```bash
awk <command-line options> <awk script> <parameters> <data file>
```
Awk can be written in two ways

- short awk statements enclosed within single quotes `'pattern { action }'` can be run directly

```bash
awk [-v var=value] [-Fr e] [- -] ’pattern { action }’ var=value datafile(s)
```

- long awk programs can be placed within a `.awk` file and run with the `-f` option

```bash
# create the awk script as 
________________________
#! /usr/bin/awk -f
...functions...
...statements...
________________________

# run it
awk [-v var=value] [-Fr e] -f scriptfile [- -] var=value datafile(s)
```

## Options, Parameters

- The `-v` option sets the variable var to value before the script is executed
- The `-F` option is used to specify a delimiter
    - This can also be done with the `BEGIN` statement inside a script
- the `--` option marks the end of **command-line options**

- **Parameters** can be passed into awk by specifying them on the command line _after_ the script
    - Can be a literal, a shell variable, or the result of a bash command  
    - These are not available until the first line of input is read, and thus cannot be accessed in the `BEGIN` procedure.



## Records and Fields

- Each line of input is split into **fields** and becomes a **record**
- By default, the field delimiter is one or more spaces and/or tabs. 
    - The delimiter can be changed using `-F` or with `OFS=`
- The default record separator is a newline.  
    - Can be changed with the `RS=` option in the `BEGIN` procedure
- Each field can be referenced by its position in the record. 
    - `$1` refers to the value of the first field; 
    - `$2` to the second field, and so on. 
    - `$0` refers to the entire record



## Writing awk Scripts

- A script is set of awk **statements**
- Each statement has
    - **patterns** which filter records to which actions apply
    - **actions** that are used for modifying or analysing data
- If no pattern is specified, the action is performed on every record
- If no action is specified, the default action, `print`, is performed on all matching records.
- **Functions** can be declared with the following syntax
    - Variables specified in the parameter-list are treated as local variables within the function. 
    - All other variables are global and can be accessed outside the function.

```bash
function some_func(parameters) { statements } 
```

- A line in an awk script is **terminated** by a newline or a semicolon
- **Flow control statements** (`do, if, for, while`) continue on the next line

```bash
if (NF > 1) { 
    name = $1
    total += $2
}
```
- A **comment** begins with a “#” and ends with a newline

## Patterns

- A pattern can be any of the following:

```
/regular expression/ 
relational expression 
BEGIN
END
pattern, pattern
```

- Regular expressions must be enclosed in slashes
- Relational expressions use Operators like `< <= > >= != ==` and `&& || ~ !~`
- The **BEGIN pattern** is applied before the first line of input is read
- the **END pattern** is applied after the last line of input is read.
    - BEGIN and END patterns must be associated with actions.
- Use `!` to negate a match



## Regular Expressions

![mage-20180321193329](/var/folders/kv/l02c_chn7tqd9cmrvyms7vy4bfc09j/T/abnerworks.Typora/image-201803211933291.png)

Within a pair of brackets, POSIX allows special notations for matching non-English
characters.			

![mage-20180321193640](/var/folders/kv/l02c_chn7tqd9cmrvyms7vy4bfc09j/T/abnerworks.Typora/image-201803211936406.png)



## Variables

- **User Defined**
    - The name of a variable cannot start with a digit.
    - Case matters
    - Can contain a string (must be quoted) or a numeric value
    - Does not need to be initialized (awk is a dynamically typed language)
        - An uninitialized variable has the empty string (“”) as its string value and 0 as its numeric value. 
        - Awk attempts to decide whether a value should be processed as a string or a number depending upon the operation.  

- **Built-in or system variables** 
    - Names consist of all capital letters.

![mage-20180321195326](/var/folders/kv/l02c_chn7tqd9cmrvyms7vy4bfc09j/T/abnerworks.Typora/image-201803211953264.png)

![mage-20180321195447](/var/folders/kv/l02c_chn7tqd9cmrvyms7vy4bfc09j/T/abnerworks.Typora/image-201803211954471.png)

- **Fields**
    - A field variable is referenced using `$n`, where n is any number 0 to NF
    - n can be supplied by 
        - a variable, such as `$NF` (meaning the last field), 
        - a constant, such as `$1` meaning the first field.

- **Arrays**
    - Arrays are variables that store a set of indexed values
    - Declared with
    - Arrays are _associative_, ie. exist as key-value pairs
        - The index can be string or numeric
    - Values are not stored in a particular order
    - Use a for loop to read the array
    - Use an if statement to check if an index exists
    - You can also delete individual elements of the array using the **delete** statement.

```bash
# creating an array
some_array[idx] = value

# accessing items
for (idx in array) {
    ...do something with idx or array[idx]...
}

# check if idx exists
if (idx in array) {
    ...do something...
}
```



## Operators 

In the order of precedence (low to high)

![mage-20180321195549](/var/folders/kv/l02c_chn7tqd9cmrvyms7vy4bfc09j/T/abnerworks.Typora/image-201803211955495.png)





