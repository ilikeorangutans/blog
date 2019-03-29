---
title: "awk Cheat Sheet"
date: 2019-03-26T11:36:48-04:00
tags:
- awk
- unix
- cheat sheet
---

I needed to crunch some data quickly and decided awk was the right tool to do so. But every time I use awk, I have to go read the manual, so I decided it's time for a cheat sheet.

### Structure of an awk script

```
# Comments begin with a pound sign
BEGIN {
  # Instructions run before the main loop
  FS = ";" # Set a Field Separator
}

# Each line of input is applied against all the following
# regular expressions and runs the instructions in the
# block:

/^$/ { print "An empty line" }

END {
  # Instructions run after the main loop
}
```

Invoke awk with a script like so:

```
$ awk -F script <input file>
```

### Matching

**Match every line:** awk will match each record against the instructions in the script. It will execute **all** matching instructions.

```
{ print $0 }           # print every single line
```

**Match blank lines:**
```
/^$/ { print "blank" } # print "blank" for every blank line
```

**Match on columns:**
```
$2 ~ /[0-9]+/ { print $2 } # print column 2 if it contains a number
```

**Relational operators to match columns:**
```
$2 < 3 { print "less than three" } # print "less than three" if column two's value is less than three
```
**Negate match:**
```
$1 !~ /[0-9]+/ { print "no number" } # print "no number if the first column contains no numbers
```

### Input and Output

Awk splits the input into records on the `RS` (RecordSeparator).
Each input record is split into fields via the `FS` variable (FieldSeparator)
or via `-F` command line flag.
Individual fields can be addressed with `$<field index>`, for example `$1` returns
the first field, `$2` the second and so on. `$0` returns the whole record.

```
$ echo 'a;b;c' | awk -F';' '{ print $1 " - " $2 " - " $3 }'
a - b - c
```

Similarly to `RS` and `FS` awk supports record and field separators for output formatting
called `ORS` (OutputRecordSeparator) and `OFS` (OutputFieldSeparator).

The `printf` function allows more control over formatting:

```
$ echo '3.1415, hello' | awk '{ printf("a float: %f, a string: %s\n", $1, $2) }'
a float: 3.141500, a string: hello
```

### Variables

Variables can simply be assigned by a name, the assignment operator, and an expression:

```
variable_name = 1 + 2
```

Variables have both a numeric and string value and awk will use whatever is appropriate. Strings
have a numeric value of `0`.

Variables can be passed into awk at the beginning of the execution as a parameter:

```
$ awk '{ print foo }' foo=bar
bar
```

These variables are not available in `BEGIN` blocks, but you can specify variable bindings at startup with `-v var=value`:

```
$ awk -v foo=bar 'BEGIN { print foo }`
bar
```

Arrays can be used just like variables and don't require initialization. Arrays are associative, i.e. both numbers and strings can be used as index.

### Predefined Variables

`RS`: Record separator

`FS`: Field separator

`NR`: number of records in input processed so far, aka line number

`NF`: number of fields in current record

`ORS`: Output record separator

`OFS`: Output field separator

### Control Flow

Awk supports `if`, `if-else`, `if-else-if-else`, and the ternary operator `expr ? action : other action`:

```
if $1 > 20 { print "many!" }
```

In terms of loops awk has `while`, `do-while`, and `for` loops. The `for` loop can be used like a traditional C style for loop:
```
for (i = 0; i < NF; i++)
  print $i # prints each field in the current record
```
or as in a simplified form for traversing array's indexes:
```
for (x in my_array) { print x ": " my_array[x] }
```

Furthermore awk has the `continue` and `break` keywords which do exactly what you would think. There's also the `exit` and `next`
keywords. `exit` does what you would expect and exits the script, `END` blocks will still be executed though.. `next` causes the
next record to be read.
