# Introduction to Shell Programming for Data Scientists

The shell is a program that takes commands from the keyboard and gives them to the operating system to perform. Nowadays, we have *graphical user interfaces (GUIs)* in addition to *command line interfaces (CLIs)* such as the shell. On most Linux systems a program called `bash` acts as the CLI. Other shell programs that can be installed in a Linux system include `zsh` and `fish`. The `Terminal` is a program that opens up a window and lets you interact with the shell.

> If the last character of your shell prompt is `#` rather than `$`, you are operating as the *superuser*. This means that you have administrative privileges. This can be potentially dangerous, since you are able to delete or overwrite any file on the system.

## 01-1 Files and Navigation

The files on a Linux system are arranged in what is called a *hierarchical directory structure*. This means that they are organized in a tree-like pattern of *directories* (called folders in other systems), which may contain files and other directories. The first directory in the file system is called the *root directory*.

| Directory            | Description                                                  |
| -------------------- | ------------------------------------------------------------ |
| /                    | The *root* directory. This is where the filesystem begins.   |
| /boot                | Contains the Linux kernel (the file called `vmlinuz`) and bootloader files. |
| /etc                 | Contains config files for the system, such as<br />`/etc/passwd` - contains essential information for each user<br />`/etc/fstab` - contains disk drives and other mounted devices<br />`/etc/hosts` - contains the network host names and IPs known to the system<br />`/etc/init.d` - contains scripts that start services at boot time |
| /bin<br />/usr/bin   | Contain programs and applications that run on the system     |
| /sbin<br />/usr/sbin | Contain programs for system administration, mostly for use by the superuser |
| /usr                 | Contains files that support user applications<br />`/usr/share/X11` - contains files for the X window system<br />`/usr/share/dict` - contains dicts for the spell checker<br />`/usr/share/doc` - contains documentation files<br />`/usr/share/man` - contains man pages<br />`/usr/src` - contains source code files (the entire Linux kernel code) |
| /usr/local           | used for the installation of software and other files that are not part of the official distribution. Users should install programs under `/usr/local/bin` |
| /var                 | contains files that change as the system is running<br />`/var/log` - contains log files that are updated as the system runs<br />`/var/spool` - contains files that are queued for some process (ex. email, print jobs) |
| /lib                 | contains shared libraries (like DLL files)                   |
| /home                | for each user, this is where they're allowed to write files  |
| /root                | superuser's home directory                                   |
| /tmp                 | programs can write their temporary files here                |
| /dev                 | contains devices that are available to the system. In UNIX, devices are treated as files, and you may read/write to devices as though they were files. |
| /proc                | virtual directory with a group of numbered entries that correspond to all the processes running on the system |
| /media, /mnt         | for mounting removable storage devices                       |

GUIs include a file manager program to view and manipulate the contents of the file system. Unlike MS Windows which can divide the file system into multiple trees (called *drives*), Linux always has a single tree.

At any given moment you are located in a single directory, called the *working directory*. When you first log on to a Linux system, the working directory is set to your *home directory*. On most systems, your home directory will be called `/home/<USER_NAME>`. This is where you put your files.

To move from the one working directory to another, we supply a *pathname* to the `cd` command. Pathnames can be *absolute* (starts from `root`) or *relative* (starts from the working directory and uses a single or two dots).

Each file created on a Linux system has the following attributes:

| Attribute         | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| File Name         | Name given to file or directory (avoid spaces)               |
| Modification Time | The last time this file was changed                          |
| Size              | File size in bytes                                           |
| Group             | Name of the group that has permissions to modify file        |
| Owner             | Name of the user who created/owns the file                   |
| Permissions       | 10-character string representing the file's access permissions<br />First character can be a `-` (ordinary file) or `d` (directory)<br />Second set of 3 characters - read, write, execute rights of the owner<br />Third set of 3 characters - rights of the file's group<br />Final set of 3 characters - rights of everyone else |

Commands like `cat`, `head`, `tail` and most commonly `less` are useful for inspecting the contents of text files. The `file` command lets you check the *type* of data in a file (text, tar, jpeg, bash script etc.)

## 01-2 Links

When inspecting directories with `ls -l` we sometimes see the filenames followed by a `->` notation.
For example:

```bash
lrwxrwxrwx     25 Jul  3 16:42 System.map -> /boot/System.map-2.0.36-3
-rw-r--r-- 105911 Oct 13  1998 System.map-2.0.36-0.7
```

These are called *symbolic links*, created using the `ln` command.

Symbolic links are a special type of file that *points to another file*. With symbolic links, it is possible for a single file to have multiple names. Here's how it works: Whenever the system is given a file name that is a symbolic link, it transparently maps it to the file it is pointing to.

This is a very handy feature, especially when we have many versions of files or libraries. For example, you might have different versions of the linux kernel installed via upgrades, and using `ln` we can create a link between the latest version and a fixed name that other programs can reference.

## 01-3 Commands

Commands can be one of 4 different kinds:

1. **An executable program** like all those files we saw in /usr/bin. These programs can be *compiled binaries* such as programs written in C and C++, or programs written in *scripting languages* such as the shell, Perl, Python, Ruby, etc.
2. **A command built into the shell itself.** Bash provides a number of commands internally called *shell builtins*. The `cd` command, for example, is a shell builtin.
3. **A shell function.** These are miniature shell scripts incorporated into the *environment*.
4. **An alias.** Commands that you can define yourselves, built from other commands.

Most commands have the syntax

```bash
command -options arguments
```

where

- *command* is the name of the command,
- *-options* is one or more adjustments to the command's behavior, and
- *arguments* is one or more "things" upon which the command operates.

For example,

```bash
ls -la /usr/bin
```

Here,

- command = `ls`, used for listing files and directories
- options = `l` for long-format, and `a` for all files (including hidden)
- argument = `/usr/bin`, the directory whose contents we wish to list out

#### Exit Status

Commands (including *scripts* and *functions*) issue a value to the system when they terminate, called an **exit status**, an integer in the range of 0 to 255 indicating the success or failure of the command’s execution.

By convention,

- **a value of zero indicates success** and
- **any other value indicates failure.**

Some commands use different exit status values to provide diagnostics for errors, while many commands simply exit with a value of one when they fail. Documentation often includes a section entitled “Exit Status,” describing what codes are used. However, a zero always indicates success.

### Inspecting Commands

```bash
type, which, help, man
```

- `type` tells you whether a comman is a shell builtin, alias or an installed program.
- `which` gives you the exact location of the executable for a given command.
  It does not work for builtins or aliases.
- `help` provides useful information on a command, s.a. its syntax, description etc.
  Most commands have a `--help` option that describe its syntax, flags/switches, and arguments.
- `man` displays the documentation manual for a command.
  On most systems `man` uses the `less` program to display paged information.

## 01-4 Wildcards

These are special characters to help you rapidly specify groups of filenames based on patterns of characters.

| Wildcard      | Meaning                                                      |
| ------------- | ------------------------------------------------------------ |
| *             | matches any character(s)                                     |
| ?             | matches one character                                        |
| [characters]  | matches characters that belong to a set. Here are some *predefined* sets `[:alnum:], [:alpha:], [:digit:], [:upper:], [:lower:]` |
| [!characters] | matches characters not in the set                            |

# 02 - I/O Redirection

The default action for most programs is to display their output on the screen. By using notations like `>` and `>>` we can *redirect* the output produced by a command to files/devices or to other commands. The order of the redirection does not matter. The only requirement is that the redirection operators (the "<" and ">") must appear after the other options and arguments in the command.

### Standard Output

- To redirect standard output to a file, the `">"` character is used.
  `ls > files.txt` will create a new file with the result of `ls`, no output is displayed on screen.
- To append content to the end of an existing file, use the `">>"` character

### Standard Input

- By default, standard input gets its contents from the keyboard.
  But like standard output, it can be redirected using the `"<"` character.
- For example, `sort < files.txt`
  Here, the `sort` command receives input from `files.txt` and displays sorted results on the screen
- `sort < files.txt > files_sorted.txt` will write the sorted results to a new file.

### Pipelines

The most useful and powerful thing you can do with I/O redirection is to connect multiple commands together with *pipelines* using the `"|"` character, feeding the output of one command to the input of another.

Examples

| Command                         | Action                                            |
| ------------------------------- | ------------------------------------------------- |
| `ls -l | less`                  | List files in long format with scrolling output   |
| `ls -lt | head`                 | See the 10 newest files in the current directory  |
| `du | sort -nr`                 | Lists directories with sizes, sorted from largest |
| `find . -type f -print | wc -l` | Displays number of files in the working directory |

### Filters

Filters take standard input and perform an operation upon it and send the results to standard output. In this way, they can be combined to process information in powerful ways.

| **Program** | **What it does**                                             |
| ----------- | ------------------------------------------------------------ |
| `sort`      | Sorts STDIN then outputs the sorted result on STDOUT.        |
| `uniq`      | Given a sorted stream of data from STDIN, it removes duplicate lines of data |
| `grep`      | Examines each line of data it receives from STDIN and outputs every line that matches a specified pattern of characters. |
| `fmt`       | Reads text from STDIN, then outputs formatted text on STDOUT. |
| `pr`        | Takes text input from standard input and splits the data into pages with page breaks, headers and footers in preparation for printing. |
| `head`      | Outputs the first few lines of its input. Useful for getting the header of a file. |
| `tail`      | Outputs the last few lines of its input. Useful for things like getting the most recent entries from a log file. |
| `tr`        | Translates characters. Can be used to perform tasks such as upper/lowercase conversions or changing line termination characters from one type to another (for example, converting DOS text files into Unix style text files). |
| `sed`       | Stream editor. Can perform more sophisticated text translations than `tr`. |
| `awk`       | An entire programming language designed for constructing filters. Extremely powerful. |

# 03 - Expansion

Each time you type a command and hit return, bash *expands* the text to unpack wildcards etc. before execution. For example

### 03-1 Wildcards

```bash
$ echo *
```

will not return "*" as you might think. The wildcard * will be expanded into filenames in the current directory before `echo` acts on it.

The mechanism by which wildcards work is called *pathname expansion*.
Try out the following

```bash
echo D*
echo *s
echo [[:upper:]]*
echo /usr/*/share
echo ~
echo ~foo
```

Similar to "*", the "~" wildcard is expanded into the pathname for your Home directory.

### 03-2 Arithmetic Expansion

The shell allows arithmetic to be performed by expansion. This allow us to use the shell prompt as a calculator. Arithmetic expansion uses the form `	$((expression))` where *expression* is an arithmetic expression consisting of integer values and arithmetic operators.

```bash
echo $(((5**2)*3))
echo Five by two is $((5/2)) leaving a remainder of $((5%2))
```

### 03-3 Brace Expansion

With it, you can create multiple text strings from a pattern containing braces. The brace expression itself may contain either a comma-separated list of strings, or a range of integers or single characters. The pattern may not contain embedded whitespace.

```bash
$ echo Front-{A,B,C}-Back
# Front-A-Back Front-B-Back Front-C-Back

$ echo Number_{1..5}
# Number_1 Number_2 Number_3 Number_4 Number_5

$ echo {Z..A}
# Z Y X W V U T S R Q P O N M L K J I H G F E D C B A

$ echo a{A{1,2},B{3,4}}b
# aA1b aA2b aB3b aB4b
```

 The most common application is to make lists of files or directories to be created. For example, to create directories to hold data by month;

```bash
$ mkdir {2007..2009}-0{1..9} {2007..2009}-{10..12}
$ ls

2007-01 2007-07 2008-01 2008-07 2009-01 2009-07
2007-02 2007-08 2008-02 2008-08 2009-02 2009-08
2007-03 2007-09 2008-03 2008-09 2009-03 2009-09
2007-04 2007-10 2008-04 2008-10 2009-04 2009-10
2007-05 2007-11 2008-05 2008-11 2009-05 2009-11
2007-06 2007-12 2008-06 2008-12 2009-06 2009-12
```



### 03-4 Parameter Expansion

The Linux system is able to store data inside *variables* that can be referenced on the CLI or inside scripts. You can inspect the list of *global variables* by running `printenv` or just `env`. To access the value inside a parameter/variable, we use the "$" notation.

```bash
$ printenv
$ echo $USER $HOME
```

- `$PARAMETER` and `${PARAMETER}` are the two most common forms of accessing contents of a variable.
- `${PARAMETER:start:stop}` can be used to extract a substring
- `${!PARAMETER}` will return the value stored inside the variable whose name is stored in `PARAMETER`







### 03-5 Command Expansion

Using the syntax `$(command)` we can use the output of a command as an expansion.

```bash
$ ls -l $(which python)
# alternatively
$ ls -l `which python`
```

### 03-6 Quoting

#### Double Quotes

- If you place text inside double quotes, all the special characters used by the shell lose their special meaning and are treated as ordinary characters.
- Exceptions are dollar, backslash and back-quote. Hence, parameter expansion, arithmetic expansion, and command substitution still take place within double quotes.

```bash
$ mv "file with spaces in its name.txt" file_with_spaces_in_its_name.txt
$ echo "$USER $((2+2)) $(cal)"

# Note the difference between

$ echo $(cal)
# the unquoted command substitution will result in a command line containing thirty-eight arguments.

$ echo "$(cal)"
# a command line with one argument that includes the embedded spaces and newlines.
```

#### Single Quotes

These are useful when you wish to suppress all expansions.

```bash
$ echo text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER
text /home/me/ls-output.txt a b foo 4 me
$ echo "text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER"
text ~/*.txt {a,b} foo 4 me
$ echo 'text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER'
text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER
```

#### Escaping Characters

To quote a single character, precede it character with a backslash. Often this is done inside double quotes to selectively prevent an expansion. It is also common to use escaping to eliminate the special meaning of a character in a filename (special characters are allowed in filenames, but using anything other than underscores is considered bad practice.) To allow a backslash character to appear, use the double-backslash.

```bash
$ echo "The balance for user $USER is: \$5.00"
# The balance for user dkhosla is: $5.00
```

Handy backslash trick: Use a backslash at the end of a line to get the shell to ignore a newline character.

```bash
$ ls -l \
   --reverse \
   --human-readable \
   --full-time
```

Note that for this trick to work, the newline must be typed immediately after the backslash. If you put a space after the backslash, the space will be ignored, not the newline.

Backslashes are also used to insert special characters into our text. These are called *backslash escape characters*, such as

- `\n` for newline,
- `\t` for tabs,
- `\a` for alerts (makes terminal beep),
- `\\` to insert a backslash.

```bash
$ echo -e "Inserting several blank lines\n\n\n"
Inserting several blank lines



$ echo -e "Words\tseparated\tby\thorizontal\ttabs."
Words separated   by  horizontal  tabs

$ echo -e "\aMy computer went \"beep\"."
My computer went "beep".

$ echo -e "DEL C:\\WIN2K\\LEGACY_OS.EXE"
DEL C:\WIN2K\LEGACY_OS.EXE
```



# 04 - Permissions

Linux systems are *multi-user*, meaning that more than one user can be operating the computer at the same time. For example, if your computer is on a network remote users can log in via `ssh` (secure shell) and operate the computer. The concept of *permissions* was implemented to prevent one user from crashing the shared system and also to stop them from interfering with the files owned by another user. The following commands are useful for managing access rights of/to files or directories:

- `chmod` - modify file access rights
- `su` - temporarily become the superuser
- `sudo` - temporarily become the superuser
- `chown` - change file ownership
- `chgrp` - change a file's group ownership

### 04-1 File Permissions

- Each file and directory is assigned access rights for (1) the **owner** of the file, (2) the **members of a group** of related users, and (3) **everybody else**.
- Rights can be assigned to **read** a file, to **write** a file, and to **execute** a file (i.e., run the file as a program).

```bash
$ ls -l /bin/bash
-rwxr-xr-x 1 root root  316848 Feb 27  2000 /bin/bash
```

Here we can see:

- The file "/bin/bash" is owned by user "root"
- The superuser has the right to read, write, and execute this file
- The file is owned by the group "root"
- Members of the group "root" can also read and execute this file
- Everybody else can read and execute this file

To interpret the 10-character permissions string, we break it down into sets of 1, 3, 3 and 3

```bash
- rwx rwx rwx
File type, - for a regular file and "d" for a directory
	Read, write, execute permissions for file owner
			Read, write, execute permissions for the group owner
					Read, write, execute permissions for everyone else
```

#### chmod

The `chmod` command is used to change the permissions of a file or directory. To use it, you specify the desired permission settings and the file or files that you wish to modify.

Using the Octal system,

```bash
rwx rwx rwx = 111 111 111
rw- rw- rw- = 110 110 110
rwx --- --- = 111 000 000

and so on...

rwx = 111 in binary = 7
rw- = 110 in binary = 6
r-x = 101 in binary = 5
r-- = 100 in binary = 4
```

For example, if we wanted to set `some_file` to have read and write permission for the owner, but wanted to keep the file private from others, we would:

```bash
$ chmod 600 some_file
```

Here are commonly user permissions:

| **Value** | **Meaning**                                                  |
| --------- | ------------------------------------------------------------ |
| **777**   | **(rwxrwxrwx)** No restrictions on permissions. Anybody may do anything. Generally not a desirable setting. |
| **755**   | **(rwxr-xr-x)** The file's owner may read, write, and execute the file. All others may read and execute the file. This setting is common for programs that are used by all users. |
| **700**   | **(rwx------)** The file's owner may read, write, and execute the file. Nobody else has any rights. This setting is useful for programs that only the owner may use and must be kept private from others. |
| **666**   | **(rw-rw-rw-)** All users may read and write the file.       |
| **644**   | **(rw-r--r--)** The owner may read and write a file, while all others may only read the file. A common setting for data files that everybody may read, but only the owner may change. |
| **600**   | **(rw-------)** The owner may read and write a file. All others have no rights. A common setting for data files that the owner wants to keep private. |

### 04-2 Directory Permissions

The `chmod` command can also be used to control the access permissions for directories. Again, we can use the octal notation to set permissions, but the meaning of the r, w, and x attributes is different:

- **r** - Allows the contents of the directory to be listed if the x attribute is also set.
- **w** - Allows files within the directory to be created, deleted, or renamed if the x attribute is also set.
- **x** - Allows a directory to be entered (i.e. `cd dir`).

Here are some useful settings for directories:



| **Value** | **Meaning**                                                  |
| --------- | ------------------------------------------------------------ |
| **777**   | **(rwxrwxrwx)** No restrictions on permissions. Anybody may list files, create new files in the directory and delete files in the directory. Generally not a good setting. |
| **755**   | **(rwxr-xr-x)** The directory owner has full access. All others may list the directory, but cannot create files nor delete them. This setting is common for directories that you wish to share with other users. |
| **700**   | **(rwx------)** The directory owner has full access. Nobody else has any rights. This setting is useful for directories that only the owner may use and must be kept private from others. |

#### chown

You can change the owner of a file by using the `chown` command. This must be done as a *superuser*.

```bash
$ su
Password:
# chown new_user some_file
# exit
$ echo Done
```

#### chgrp

The group ownership of a file or directory may be changed with `chgrp`. You must be the owner of the file or directory to perform a `chgrp`.

```bash
$ chgrp new_group some_file
```

# 06 - Job Control

As with any multitasking operating system, Linux executes multiple, simultaneous processes. Actually, a single processor computer can only execute one process at a time but the Linux kernel manages to give each process its turn at the processor and each appears to be running at the same time.

There are several commands that can be used to control processes. They are:

- `ps` - list the processes running on the system
- `kill` - send a signal to one or more processes (usually to "kill" a process)
- `jobs` - an alternate way of listing your own processes
- `bg` - put a process in the background
- `fg` - put a process in the forground

## 06-1 Working with Processes

#### Starting, Suspending, Resuming

Most programs (including those with a GUI) can be launched from the command line. For example

```bash
$ jupyter notebook
```

In some cases, the shell will wait for you to exit the launched program to finish before control is returned to the user. The "&" symbol can be used to put a process in the background, and CTRL-Z can be used to suspend a running process (can be revived by running `bg`)

#### Listing

To display a list of the processes we have launched, use either of two commands - `jobs` and `ps`. If you use `jobs` you will get back a *job number*, whereas with `ps`, you are given a *process id (PID)*.

```bash
$ ps
PID TTY TIME CMD
1211 pts/4 00:00:00 bash
1246 pts/4 00:00:00 xload
1247 pts/4 00:00:00 ps
```

#### Killing

To get rid of an unresponsive process, we have the `kill` command, used to send *signals* to processes (one of which can terminate it.) Well written programs listen for signals from the operating system and respond to them, most often to allow some graceful method of terminating.

For example, a text editor might listen for any signal that indicates that the user is logging off, or that the computer is shutting down. When it receives this signal, it saves the work in progress before it exits.

| **Signal** | **Name**    | **Description**                                              |
| ---------- | ----------- | ------------------------------------------------------------ |
| **1**      | **SIGHUP**  | *Hang up*. Programs can listen for this signal and act upon it. This signal is sent to processes running in a terminal when you close the terminal. |
| **2**      | **SIGINT**  | *Interrupt*. Programs can process this signal and act upon it. You can also issue this signal directly by typing CTRL-C in the terminal where the program is running. |
| **15**     | **SIGTERM** | *Terminate*. Programs can process this signal and act upon it. This is the default signal sent by the `kill` command if no signal is specified. |
| **9**      | **SIGKILL** | *Kill*. This signal causes the immediate termination of the process by the Linux kernel. Programs cannot listen for this signal. |

For example,

```bash
# To kill a process using its job id
$ kill %1

# To kill a process using its process id
$ kill 1246
```

Now let's suppose that you have a program that is stuck and you want to get rid of it. Here's what you do:

1. Use the `ps` command to get the process id (PID) of the process you want to terminate.
2. Issue a `kill` command for that PID.
3. If the process refuses to terminate (i.e., it is ignoring the signal), send increasingly harsh signals until it does terminate.

```bash
$ ps x | grep bad_program

PID TTY STAT TIME COMMAND
2931 pts/5 SN 0:00 bad_program

$ kill -SIGTERM 2931
$ kill -SIGKILL 2931
```

---

# 07 - Scripting

The shell is both a powerful CLI and a scripting language interpreter. A shell script is a text file created using a text editor (like `nano`, `vim`, `emacs` etc.) containing a series of commands.

To successfully write a shell script, you have to do three things:

1. Write a script
2. Give the shell permission to execute it
3. Put it somewhere the shell can find it

The basic structure of a script is:

```
#!SHEBANG

<CONFIGURATION_VARIABLES>

<FUNCTION_DEFINITIONS>

<MAIN_CODE>
```

## 07-1 Hello Bash

#### Create the script

Create a file called `hello_bash` with the following content

```bash
#!/bin/bash
# My first script

echo "Hello World!"
```

- The first line of the script, called the **`shebang`** tells the shell which program (`/bin/bash` in our script) to use to interpret the script. Other scripting languages like Python, awk, Perl etc. use this mechanism.
- The second line is a *comment*. Everything that appears after a "#" symbol is ignored by `bash`.
- The third line is the `echo` *command* which simply prints a message to the screen.

#### Set Permissions

```bash
$ chmod 755 hello_bash
```

- Using the `chmod` command with the argument `755`, we give ourself the permission to read-write-execute the file, while others (group members, all others) are permitted only to read and execute.

#### Add scripts directory to PATH

When you run a command or script, the system searches through a list of pre-defined directories for the command or script (known as the **`PATH`**).

Inspect this list using:

```bash
$ echo $PATH | tr ":" "\n" | nl
```

You can add directories to your `PATH` by concatenating them to the existing PATH, telling bash to search for commands/scripts in a predefined directory.

The proper way to do this is to store all user scripts in a single directory (called `bin` , a subdirectory of `$HOME`) and add it to PATH in your `.bash_profile` or `.bashrc`

```bash
$ export PATH=$PATH:$HOME/bin
```

Now you should be able to run your scripts stored under `$HOME/bin` by simply typing its name on the prompt.

## 07-2 Startup Files & Environment

When a user account is created, the system puts certain scripts in his home directory. These act like configuration files and allow the user to customize his sessions.

For each session, the system keeps certains facts (such as *variables*, *functions* and *aliases*) in its memory. Together, these are referred to as the **`environment`**. These include `PATH, USER, HOME` etc. We can list these out using the `set`, `env`, or `printenv` commands.

#### What happens when a user logs in?

On first login by a user, the bash program starts and does the following:

- If it is a shared system, ask user to input username and password (*login shell*).
  Then, read the following files

| File              | Contents                                                     |
| ----------------- | ------------------------------------------------------------ |
| `/etc/profile`    | Global config script, applies to all users                   |
| `~/.bash_profile` | User's personal startup file which can override global config options |
| `~/.bash_login`   | If `.bash_profile` is not found, bash tries to read this script |
| `~/.profile`      | If neither `.bash_profile` nor `.bash_login` are found, bash attempts to read this. |

- If the user starts the terminal with the GUI (*non-login shell*), read the following

| File               | Contents                                                     |
| ------------------ | ------------------------------------------------------------ |
| `/etc/bash.bashrc` | Global config script, applies to all users                   |
| `~/.bashrc`        | User's personal startup file which can override global config options |

The **`~/.bashrc`** file is probably **the most important startup file** from the ordinary user’s point of view, since it is almost always read. Non-login shells read it by default and most startup files for login shells are written in such a way as to read the `~/.bashrc` file as well.

A typical `.bash_profile` script looks like

```bash
# .bash_profile

# Get aliases and functions
if [ -f ~/.bashrc ]; then
		. ~/.bashrc
fi

# Get user's environment and startup programs
PATH=$PATH:$HOME/bin
export PATH
```

The `export` command tells the shell to make the contents of PATH available to child processes of this shell.

## 07-3 Aliases

An alias is an easy way to create a new command which acts as an abbreviation for a longer one. It has the following syntax:

```bash
alias name=value

# example
alias today='date +"%A, %B %-d, %Y"'
```

where *name* is the name of the new command and *value* is the text to be executed whenever *name* is entered on the command line.

The `alias` command is just another shell builtin. You can create your aliases directly at the command prompt; however they will only remain in effect during your current shell session.

To make `alias`es persist, add them to your startup files like `.bashrc` or `.zshrc`

## 07-4 Functions

Aliases are good for very simple commands, but if you want to create something more complex, you should try *shell functions* . Shell functions can be thought of as tiny programs that take arguments and produce outputs.

The syntax for defining a function is

```bash
fn_name() {
	commands
}

# example
today() {
    echo -n "Today's date is: "
    date +"%A, %B %-d, %Y"
}
```

As with *aliases*, it is good practice to add functions to the startup files like `bashrc` or `zshrc`, or else the defined function will perish when the session ends.

## 07-5 Here Scripts

Essentially, *Here* scripts are files created inside scripts using a form of I/O redirection that allows us to pass content to the STDIN of a command which takes files as input.

Syntax

```bash
command << token
<content>
token
```

where a `token` can be any string, used to mark the beginning and end of the content.

Let's write a shell script to produce a HTML web page.

```bash
#!/bin/bash
# A script to produce an HTML file

cat << _HSTKN_
	<html>
	<head>
			<title>
			Page Title
			</title>
  </head>

  <body>
  		Body
  </body>
  </html>
_HSTKN_
```

Changing the the "<<" to "<<-" causes bash to ignore the leading tabs (but not spaces) in the here script. Now, we can produce an HTML by simply running the script, and redirecting output to a `.html` file.



## 07-6 Using Variables in Scripts

Like other languages, bash uses variables to store values. Variables are given lowercase names by conventions that begin with a letter and cannot contain spaces/punctuation (underscores are allowed.)

#### Creating variables

When you need the **name** of a variable, you write **only the name**, for example

```bash
# to set variables
picture=/usr/share/images/foo.png

# to name variables to be used by the read builtin command
read picture

# to name variables to be unset
unset picture
```

#### Whitespace

Putting spaces on either or both sides of the equal-sign (`=`) when assigning a value to a variable **will** fail. The only valid form is **no spaces between the variable name and assigned value**

#### Using variables

When you need the **content** of a variable (called *expanding*), you prefix its name with **a dollar-sign**, like

```bash
echo "The used picture is: $picture"
```

Note that within Arithmetic expressions, the dollar sign is not needed

```bash
a=5
((b=a+5))
echo $b
```



#### Defaults

##### Using default values

```bash
${PARAMETER:-WORD}
```

If `PARAMETER` is unset (never was defined) or null (empty), this one expands to `WORD`, otherwise it expands to the value of `PARAMETER`, as if it just was `${PARAMETER}`.

```bash
${PARAMETER-WORD}
```

If you omit the `:` (colon), , the default value is only used when the parameter was **unset**, not when it was empty.

##### Setting default values

```bash
${PARAMETER:=WORD}
```

The default text *WORD* is expanded and **assigned** to the parameter, if it was unset or null.

```bash
${PARAMETER=WORD}
```

This works only if `PARAMETER` was unset.

**Example**

If reading input from user, or picking up passed parameters, use

```bash
#!/bin/bash
echo "Press Y to continue, N to exit"
echo "You have 5 seconds to choose"
read -t 5
choice=${REPLY:-N}
if [ $choice = "Y" ]; then
	echo "Moving on."
else
	echo "Terminating."
fi
```



#### Environment Variables

These are special variables set up by the *startup files* when a session starts. Commands like `env, printenv, set` can be used to inspect available environment variables.

Environment variables are treated more like *constants* as they rarely change, and are given uppercase names by convention.

Let's modify our here-script to use variables

```bash
#!/bin/bash
# A script to produce an HTML file

page_title="System Information"

cat << _HSTKN_
	<html>
	<head>
			<title>
			$page_title
			</title>
  </head>

  <body>
  		<h1>$USER on $HOSTNAME</h1>
  </body>
  </html>
_HSTKN_
```

#### Variable Scoping

In Bash, the scope of user variables is generally *global*. That means, it does **not** matter whether a variable is set in the "main program" or in a "function", the variable is defined everywhere.

Compare the following *equivalent* code snippets:

```bash
myvariable=test
echo $myvariable
```

```bash
myfunction() {
  myvariable=test
}

myfunction
echo $myvariable
```

In both cases, the variable `myvariable` is set and accessible from everywhere in that script, both in functions and in the "main program".

> **Attention**
> When you set variables in a child process, for example a *subshell* (when using *pipes*) , they will be set there, but you will **never** have access to them outside of that subshell.

####  `declare` and `local`

Variables defined using the *local* keyword (or the `declare` command) tags a variable to be treated completely local and separate inside the function where it was declared.

```bash
foo=external

printvalue() {
local foo=internal
echo $foo
}

echo $foo # this will print "external"
printvalue # this will print "internal"
```

#### `export`

Every UNIX process runs in a so-called *environment*, within which are contained the so-called *environment variables.* Whenever a child process is created, the whole environment is copied to the new process and thus every child process has access to all environment variables.

To create environment variables, use

```bash
export NEW_ENV_VAR=value
```



## 07-7 Using commands in Scripts

Let's use *command substitution* to pass the output of a command to the content of a script. Recall that this can be done using `$(command)` This is preferred over using back-ticks.

```bash
#!/bin/bash
# A script to produce an HTML file

page_title="System Information"

cat << _HSTKN_
	<html>
	<head>
			<title>
			$page_title
			</title>
  </head>

  <body>
  		<h1>Machine $HOSTNAME</h1>
  		<p>Updated on $(date) by $USER</p>
  </body>
  </html>
_HSTKN_
```

## 07-8 Shell Functions

With *shell functions* we can create commands to do what existing commands cannot. They must be declared in the script before you use them. The function body must contain at least one valid command (`return` or `echo` is acceptable as a placeholder.)

Functions syntax

```bash
function_name()
{
	echo "This is a function."
}
```

Let's return to our HTML producing shell script and write functions to produce additional system info

```bash
#!/bin/bash
# A script to produce an HTML file

page_title="System Information"

show_uptime()
{
		echo "<h2>System has been running for</h2>"
		echo "<pre>"
		uptime
		echo "</pre>"
}

show_drive_space()
{
		echo "<h2>Filesystem Space</h2>"
		echo "<pre>"
		df
		echo "</pre>"
}

show_home_space()
{
		echo "<h2>Home Directory Size</h2>"
		echo "<pre>"
		du -s $HOME/* | sort -nr
		echo "</pre>"
}

show_system_info()
{
		echo "<h2>System release info</h2>"
		echo "<p>To be implemented</p>"
}

cat << _HSTKN_
	<html>
	<head>
			<title>
			$page_title
			</title>
  </head>

  <body>
  		<h1>Machine $HOSTNAME</h1>
  		<p>Updated on $(date) by $USER</p>
  		$(show_uptime)
			$(show_drive_space)
			$(show_home_space)
			$(show_system_info)		
  </body>
  </html>
_HSTKN_
```

# 08 - Flow Control

To add intelligence to our script, we make use of commands such as `if, test, exit`

## 08-1 `if`

It makes a decision based on the *exit status* of a command. Syntax:

```bash
if commands; then
commands
[elif commands; then
commands ...]
[else
commands]
fi
```

What the `if` statement really does is evaluate the success or failure of commands.  The `test` command is used most often with the `if` command to perform true/false decisions. If the given expression is true, `test` exits with a status of zero; otherwise it exits with a status of 1.

Note that indentation is not required, but is considered good practice to improve readability.

It is unusual in that it has two different syntactic forms:

```bash
# Testing if a command returns true (exit status 0)
test <expression>
# or
[ <expression> ]
```

Note that the spaces between the square brackets and the beginning and end of the expression are required.

Here is a partial list of the conditions that `test` can evaluate.

| **Expression**         | **Description**                                              |
| ---------------------- | ------------------------------------------------------------ |
| -d *file*              | True if *file* is a directory.                               |
| -e *file*              | True if *file* exists.                                       |
| -f *file*              | True if *file* exists and is a regular file.                 |
| -L *file*              | True if *file* is a symbolic link.                           |
| -r *file*              | True if *file* is a file readable by you.                    |
| -w *file*              | True if *file* is a file writable by you.                    |
| -x *file*              | True if *file* is a file executable by you.                  |
| *file1* -nt *file2*    | True if *file1* is newer than (according to modification time) *file2* |
| *file1* -ot *file2*    | True if *file1* is older than *file2*                        |
| -z *string*            | True if *string* is empty.                                   |
| -n *string*            | True if *string* is not empty.                               |
| *string1* = *string2*  | True if *string1* equals *string2.*                          |
| *string1* != *string2* | True if *string1* does not equal *string2.*                  |

The syntax can be written out in a few different forms

```bash
# preferred form
if [ -f .bash_profile ]; then
    echo "You have a .bash_profile. Things are fine."
else
    echo "Yikes! You have no .bash_profile!"
fi

# alternate 1
if [ -f .bash_profile ]
then
    echo "You have a .bash_profile. Things are fine."
else
    echo "Yikes! You have no .bash_profile!"
fi

# alternate 2
if [ -f .bash_profile ]
then echo "You have a .bash_profile. Things are fine."
else echo "Yikes! You have no .bash_profile!"
fi
```

### exit

To set the exit status when our scripts finish, use the `exit` command. It causes the script to terminate immediately and set the exit status to whatever value is given as an argument.

### Testing for superuser

For scripts that can only be run by a superuser, we can use the `id` command to check if the user attempting to execute the script has root access.

For a superuser, the `id -u` command returns a `0`.

```bash
if [ "$(id -u)" = "0" ]; then
		echo "Welcome, superuser."
else
		echo "Only a superuser can run this script." >&2
		exit 1
fi
```

Note the `>&2` at the end of the `echo` command in the `else` block. This is a way of I/O redirection, that sends the error message to STDERR instead of STDOUT. This is a useful feature, it prevents error messages to be written to the output file of a script.

## 08-2 `case`

Similar to the CASE-WHEN construct in SQL, the `case` command is multiple-choice.

Unlike the simple binary branching created with `if`,
a `case` supports several possible outcomes based on the evaluation of a value.

**Syntax**

```bash
case word in
    patterns ) commands ;;
esac
```

- `case` selectively executes statements if word matches a pattern.
- Patterns can be literal text or wildcards.
- You can have multiple patterns separated by the "`|`" character.

**Example**

```bash
#!/bin/bash

echo -n "Please enter a character: "
read char
case $char in
	                    [0-9] ) echo "You entered a number.";;
	[[:lower:]] | [[:upper:]] ) echo "You entered an alphabet.";;
	                        * ) echo "Entered character is not alphanumeric."
esac	                        
```

## 08-3 Loops

Looping is repeatedly executing a section of your program based on the exit status of a command. The shell provides three commands for looping: `while`, `until` and `for`.

#### `while`

- The `while` command causes a block of code to be executed over and over,
  as long as the exit status of a specified *test* is true.

- Each time the block of code is completed, the test command's exit status is evaluated again.

Syntax

```bash
while [ condition ]; do
	actions
done
```

Example

```bash
#!/bin/bash
number=0
while [ "$number" -lt 10 ]; do
    echo "Number = $number"
    number=$((number + 1))
done
```

#### `until`

- The `until` command works exactly the same way,
  except the block of code is repeated as long as the specified command's exit status is *false*.

Example

```bash
#!/bin/bash

selection=
until [ "$selection" = "0" ]; do
    echo "
    PROGRAM MENU
    1 - Display free disk space
    2 - Display free memory

    0 - exit program
"
    echo -n "Enter selection: "
    read selection
    echo ""
    case $selection in
        1 ) df ;;
        2 ) free ;;
        0 ) exit ;;
        * ) echo "Please enter 1, 2, or 0"
    esac
done
```

#### `for`

It is used for constructing loops that run for each value in a list of values.
Here's how it works:

- assigns a value from the list to the specified variable,
- executes the commands,  and
- repeats this over and over until the list is empty.

Syntax

```bash
for variable in list; do
	commands
done
```

The interesting thing about `for` is the many ways you can construct the list of words.
All kinds of expansions can be used.

# 09 - Troubleshooting

When bash encounters a syntax error, it halts program execution with an error message, such as

```bash
./myscript.sh: [: =: unary operator expected
```

Here, the shell is trying to tell us is that there is only one item around the '=' (a binary operator).
There should be a unary operator (like "`!`") that only operates on a single item.

#### Advice for Troubleshooting

- Remember that the shell spends a lot of its life expanding text.
  Try to visualize what the shell sees for a given piece of code.
-  Consider what happens if a variable is set to equal nothing.
  For example, if the user inputs a Null value.
- Mistakes in one line will cause problems later in the script.
- Use `echo` commands liberally to verify assumptions when developing scripts.
  Test your scripts frequently as you are writing them so there is less new code to test.
- With loops, try to include a *timeout* condition to avoid endless looping.
  The loop should count the number of attempts, or calculate the amount of time it has waited for something to happen. If the number of tries or the amount of time allowed is exceeded, the loop should exit or fall back to a default.
- Check the **exit status** of programs.

#### Empty Variables

Writing `some_variable=` is perfectly OK syntax, used to set a variable's value to *nothing* (null.) However, we must be careful when using such empty variables in a conditional statement.

Consider,

```bash
number=
if [ $number = "1"]; then
	echo "Number equals 1"
```

What the shell will essentially see is

```bash
if [  = "1" ]; then
```

and produce an error, because `=` being a binary operator expects two arguments to work with. Since there is only one argument, the shell will think that there should be a unary operator here instead.

To fix this, whenever we have a variable that could be empty, use

```bash
if [ "$number" = "1" ]; then
```

which will expand to

```bash
if [ "" = "1" ]; then
```

and the condition will be evaluated without error.

Two more options to deal with potentially empty variables:

```bash
# use double square brackets
if [[ $(grep text file) = '' ]]; then
...

# use pad variable
if [[ x$(grep text file) = 'x' ]]; then
...
```



#### Missing Quotes

If you forget to supply closing quotation marks, the script will fail with an error such as

```bash
./myscript: line 8: unexpected EOF while looking for matching "
./myscript: line 10 syntax error: unexpected end of file
```

This happens because the shell keeps looking for the closing quotes to mark the end of the string but runs into the EOF before it finds them.

#### The `set` command

To see what bash is doing when it starts to run your script, use the `-x` switch in the shebang

```bash
#!/bin/bash -x
# or
set -x
```

Now, when you run your script, bash will display each line (with expansions performed) as it executes it. This technique is called *tracing*.

Alternately, you can use the `set` command within your script to turn tracing on and off.
Use `set -x` to turn tracing on and `set +x` to turn tracing off.

For example

```bash
#!/bin/bash
number=1
set -x
if [ $number = "1" ]; then
    echo "Number equals 1"
else
    echo "Number does not equal 1"
fi
set +x       
```

To make bash exit a script if any command fails (returns nonzero exit code)

```bash
#!/bin/bash -e
# or
set -e
```

# 10 - User Input and Arithmetic

#### `read`

Scripts can be made interactive by requesting and acting on user's responses.

- To get input from the keyboard, use the `read` command and assign it to a variable.
- If you don't give the `read` command the name of a variable to assign its input,
  it will use the environment variable `REPLY`.

*Options*

- The `-t` option followed by a number of seconds provides an automatic timeout for the `read` command. Useful in scripts that must continue (perhaps resorting to a default response) even if the user does not answer the prompts.
- The `-s` option causes the user's typing not to be displayed. This is useful when you are asking the user to type in a password or other confidential information.

Example

```bash
#!/bin/bash
echo -n "What is your name > "
read name
echo "Hello, $name. Have a good day."
```

Note that "`-n`" given to the `echo` command causes it to keep the cursor on the same line.

#### `read` with timeout

Use it inside an `if` block,

```bash
#!/bin/bash
echo -n "Press Y to continue. "
if read -t 5 choice; then
	echo "Cool, moving on."
else
	echo "Quitting."
fi
```

Or use it to assign a default value

```bash
#!/bin/bash
TMOUT=5
echo What is your name?
echo You have 5 seconds to respond...
read
username=${REPLY:-new_user}
echo Hello, $username
```

This example makes use of the `TMOUT` shell variable, and assigns a default value to the variable.

#### Integer Arithmetic

- By default, the shell is capable of performing arithmetic with *integers.*
  (For floats, use the `bc` program.)
- Arithmetic expressions are written surrounded by double-parentheses.
  The leading "`$`" is not needed to reference variables inside the arithmetic expression.
  Whitespaces are ignored.

```bash
$ echo $((2+3))
$ echo $((a * b))
```

- We can perform BEDMAS operations

```bash
#!/bin/bash
num_1=0
num_2=0
echo -n "Enter first number: "
read num_1
echo -n "Enter second number: "
read num_2

echo "Add = $((num_1 + num_2))"
echo "Subtract = $((num_1 - num_2))"
echo "Multiply = $((num_1 * num_2))"
echo "Divide = $((num_1 / num_2))"
echo "Exponential = $((num_1 ** num_2))"
echo "Modulo = $((num_1 % num_2))"
```

- Numbers that get too large *overflow*
- Divide-by-zero will raise an error.

# 11 - Positional Parameters

- To handle options on the command line, we use a facility in the shell called *positional parameters*.
- Positional parameters are a series of special variables (`$0` through `$9`)
  that contain the contents of the command.
- For example, if we ran `my_script` with the following arguments,

```bash
./my_script arg1 arg2 arg3
```

Inside `my_script` we could access the following data:

| Variable     | Contains                                                     |
| ------------ | ------------------------------------------------------------ |
| `$0`         | the name of the command: `my_script`                         |
| `$1, $2, $3` | the arguments passed: `arg1, arg2` and `arg3`                |
| `$#`         | the number of items supplied on the command line <br />including the name of the command |
| `$@`         | a list of all items supplied as arguments, <br />useful with for loops |

#### Defaults for parameters

If an expected parameter is not supplied, it is possible to assign a default value using the syntax below. Now, if `$1` is empty, the variable FIRST_ARG will take the value "no_first_arg" .

```bash
#!/bin/bash
FIRST_ARG="${1:-no_first_arg}"
echo ${FIRST_ARG}
```

#### The `shift` command

- `shift` is a shell builtin that operates on the positional parameters.
- Each time you invoke `shift`, it "shifts" all the positional parameters down by one.
  `$2` becomes `$1`, `$3` becomes `$2`, `$4` becomes `$3`, and so on.
- When used inside a loop, `shift` enables us to read the *next* argument in the array.

Example

```bash
#!/bin/bash
echo "You supplied $# positional arguments"
while [ "$1" != "" ]; do
        echo "Flag: $1, Option: $2"
        shift 2
done
```

#### Looping through arguments

The shell variable "$@" contains the list of command line arguments. This technique is often used to process a list of files on the command line.

Example

```bash
#!/bin/bash

for filename in "$@"; do
    result=

    # Check if exists
    if [ -f "$filename" ]; then
        result="$filename is a regular file"
    else
        if [ -d "$filename" ]; then
            result="$filename is a directory"
        fi
    fi

    # Check if writable
    if [ -w "$filename" ]; then
        result="$result and it is writable"
    else
        result="$result and it is not writable"
    fi

    echo "$result"
done
```

#### The `getopts` command



# 12 - Error Handling

The difference between a good program and a poor one is often measured in terms of the program's *robustness*. That is, the program's ability to handle situations in which something goes wrong.

#### Best Practices

Every well-written program returns an exit status when it finishes. If a program finishes successfully, the exit status will be zero. If the exit status is anything other than zero, then the program failed in some way.

- Check the exit status of programs you call in your scripts.
- Your scripts should return a meaningful exit status when they finish.

#### Checking the Exit Status with `$?`

The environment variable **`$?`** contains the exit status of the last command executed.

```bash
$ true; echo $?
0
$ false; echo $?
1
```

The `true` and `false` commands are programs that do nothing except return an exit status of zero and one, respectively.

> NOTE: Caution with `grep`
>
> Exit codes read using `$?` from the `grep` program represent
> `0=found, 1=not-found`
> and not
>  `0=success, 1=failure`

An example

```bash
#!/bin/bash
cd $1
if [ "$?" = "0" ]; then
	rm *
else
	echo "Could not cd into $1" 1>&2
	exit 1
fi
```

This script will `cd` to a given directory, and empty it. If the `cd` command fails, it returns an error message and an exit code of 1 indicating that some error has occurred.

#### An error exit function

Since we will be checking for errors often in our programs, it makes sense to write a function that will display error messages and return an error exit status.

```bash
error_exit()
{
	echo ${LINENO}: "$1" 1>&2
	exit 1
}

if cd $some_dir; then
	rm *
else
	error_exit "Could not change directory. Aborting!"
fi
```

#### `AND, OR` lists

The control operators `&&` and `||` denote AND lists and OR lists, respectively and help  you execute a command based on whether or not the previous command completed successfully.

```bash
command1 && command2
# run command2 iff command1 is successful (exit status 0)

command1 || command2
# run command2 iff command1 fails (exit status != 0)
```

The exit status of AND and OR lists is the exit status of the last command executed in the list.

Examples

```bash
$ true && echo "echo will run"
$ false && echo "echo will not run"
$ true || echo "echo will not run"
$ false || echo "echo will run"
```

#### Cleaning up with `trap`

Sometimes, a signal like SIGINT can come along and make your script terminate and leave behind unfinished tasks or temporary files. Good practice would dictate that we delete the temporary files when the script terminates - but how?

The `trap` command allows you to execute a command when a signal is received by your script.

Syntax

```bash
trap arg signals
```

where

- "signals" is a list of signals to intercept by name or by number
- "arg" is a command to execute when one of the signals is received

Example

```bash
trap "rm $TEMP_FILE; exit" SIGHUP SIGINT SIGTERM
```

It is a good practice to create a function that is called when you want to perform any actions at the end of your script in response to a signal.

```bash
# housekeeping
clean_up() {
	rm $TEMP_FILE
	exit
}

trap clean_up SIGHUP SIGINT SIGTERM
```



#### `SIGKILL` and lock files

There is one signal that you cannot trap: SIGKILL or signal 9. The kernel immediately terminates any process sent this signal and no signal handling is performed.

Often this is OK, but with many programs it's not. In particular, many complex programs create *lock files* to prevent multiple copies of the program from running at the same time. When a program that uses a lock file is sent a `SIGKILL`, it doesn't get the chance to remove the lock file when it terminates. The presence of the lock file will prevent the program from restarting until the lock file is manually removed.

Be warned. Use SIGKILL as a last resort.

# 13 - Bash Tricks

### Using `<()`

Just like we use `$()` to use the output of a command as input to other commands,
the `<()` is used to get the output of a command and treat it as a *file,* for use with commands/programs that take files as input.

Example

```bash
# Consider
$ grep somestring file1 > /tmp/a
$ grep somestring file2 > /tmp/b
$ diff /tmp/a /tmp/b

# Replace by
$ diff <(grep somestring file1) <(grep something file2)
```
