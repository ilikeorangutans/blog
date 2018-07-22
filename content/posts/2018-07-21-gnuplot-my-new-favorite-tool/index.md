---
title: "gnuplot - My New Favorite Tool"
date: 2018-07-21T20:50:44-04:00
tags:
  - gnuplot
  - books
  - CSV
---

I recently had the need to quickly visualize some data and none of the systems I usually work with had the data.
Initially I dumped the data in Google Sheets and created a chart there, but that was slow and didn't really scale well.
The data had to be cleaned, brought into the right format, columns had to be selected and charts created. At this point
I faintly recalled reading about [gnuplot](http://www.gnuplot.info/) which, despite its name, has no affiliation with the
GNU project.

After some hacking I got some graphs working, but it took me a while to get what I wanted. The syntax was not initially
intuitive, partially because I decided to go straight to the tool without reading any docs first. I liked what I had at
my hands, but I wanted to learn more so I picked up [Gnuplot in Action, Second
Edition](https://www.manning.com/books/gnuplot-in-action-second-edition) and started reading. The book is fantastic so
far and I'm condensing some notes here about this magnificent tool, so I can quickly go back and find them.

## It's Interactive!

The first thing I got realized is that gnuplot is actually meant to be used interactively. I've only used it by calling
it from the command line and feeding data straight into it, which is good if you're scripting something, but it made
getting the graphs a really cumbersome trial and error. Using it interactively is pretty great as every plot you issue
is automatically rendered on the current terminal.

To get you started, install gnuplot (you know how to do that) and start it. You'll get an interactive terminal:

```
gnuplot> plot sin(x)
```

Depending on you version it might help to specify a range:

```
gnuplot> plot [-6:6] sin(x)
```

You'll get a little window with your plotted function:

{{% figure src="sin.png" alt="sine function plotted by gnuplot" title="" class="figure" %}}

## Plotting Data From Files

Plotting functions is fun and the nerd in me enjoys it, but there's only so much use in plotting random polynomials. The
real power of gnuplot is by reading data from files. Reading input from files is trivially easy:

```
gnuplot> plot "file-white-space-separated-content" using 1:2
```
This will read the file `file-white-space-separated-content` and plot the first column on the x-axis and the second
column on the y-axis. Note that the filename has to be in quotes.

## Anatomy of the Plot Command

This is my understanding of the plot command using semi-regular expressions:

```
plot [[X-RANGE]:[Y-RANGE]] "<DATAFILE>" using <X-DATA>:<Y-DATA> title <TITLE> [with <DRAW-METHOD>] [, using <X-DATA>:<Y-DATA> [with <DRAW-METHOD>]]*
```

Let me break down the pieces:

X-RANGE and Y-RANGE
: Optional, specifies the x and y range to be plotted. If not specified gnuplot will pick based on the data. You can use
this to filter by specifying only one part of the range, for example `plot [][1000:]` will only plot y values larger
than `1000`.

DATAFILE
: The source from which gnuplot reads data. Can be a filename or a `-` (dash) for stdin or an empty string `""` to use
the previously used file, very useful when plotting more than one series.

TITLE
: Label for this series. gnuplot will always label a series, but it might not pick the best title.

X-DATA,Y-DATA
: Specify the columns that we want gnuplot to render, with `1` being the first column and `0` and implicit, increasing
column. If an argument is enclosed in parentheses it's evaluated as an expression with `$1` being the first column, and
so on.

DRAW-METHOD
: Tells gnuplot how you would like it to visualize your series. Among the available options are `lines`, `boxes`,
`dots`, and many more. See `help plot with` for a full list of available styles.

## Useful gnuplot Snippets

Here's a bunch of useful snippets I regularly use to quickly crunch some numbers and visualize them:

### Reading CSV Files

```
gnuplot> set datafile separator ","
```
or
```
gnuplot> set datafile separator comma
```

### Reading Time Series Data

The data I was dealing with as pulled from a running system and had memory consumption stats and a Unix timestamp.
Reading time series data with gnuplot is straightforward: you set the data format for the x-axis and the time format.

```
gnuplot> set xdata time
gnuplot> set timefmt "%s" # %s is for Unix timestamps, see all formats with help set timefmt
gnuplot> plot "job1.csv" using 1:4 with lines
```

### Human Readable Sizes

I deal with byte counts and I find the scientific notation not as intuitive. I prefer the traditionally used prefixes
(from this helpful [StackOverflow
answer](https://stackoverflow.com/questions/25123624/gnuplot-y-axis-format-convert-bytes-to-megabytes#25125788)):

```
gnuplot> set format y "%.0s%cB"
```

### Rendering PNGs

```
gnuplot> set terminal pngcairo size <WIDTH>,<HEIGHT> # or just png
gnuplot> set output "filename.png"
gnuplot> plot ...
```

The `pngcairo` terminal supports more options, see `help set terminal pngcairo` for more details.


## Neat Example

Here's a graph that I generated from some JVM memory statistics from an app that I work with. I know, one could use
visualvm, but in a distributed system I find it easier to just scrape the stats from JSON and plot them because it is so
fast and gives me a really quick overview of what's happening:

{{% figure src="mem-graph.png" alt="sine function plotted by gnuplot" title="" class="figure" %}}

Here are the necessary gnuplot commands:
```
set xdata times
set timeformat "%s"
set terminal pngcairo size 967,500
set output "mem-graph.png"
set format y "%.0s%cB"
plot "job1.csv" using 1:4 title "used" with lines, "" using 1:5 title "committed" with lines, "" using 1:3 title
"max" with lines
```
