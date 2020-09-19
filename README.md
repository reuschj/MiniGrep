# MiniGrep

This is a simple, re-implementation of the `grep` command-line search tool. It works like `grep` and has a few of the basic search features of `grep`.

This was inspired by a similar `minigrep` command line tool that's part of a [Rust tutorial](https://doc.rust-lang.org/book/ch12-00-an-io-project.html) to build an I/O command line project.

There is no reason to use this over the `grep`. This was merely created as a learning project.

Feel free to try it out and tinker with it as needed, but it's not recommended for use for anything critical.

## Building
To run:

```
$ swift run minigrep <query> <filename> <options>
```

To build:

```
$ swift build
```
or
```
$ swift build -c release
```

## Usage

```
minigrep <query> <filename> [--all] [--no-all] [--tagged] [--no-tagged] [--case-insensitive] [--no-case-insensitive] [--highlight-color <highlight-color>]
```

Basic usage is just like `grep`:

```
$ minigrep query filename.txt
```

`minigrep` will display the lines with query found and with the query highlighted in yellow.

## Arguments
Argument | Description
---- | ----
`<query>` | The search string you are looking for.
`<filename>` | The path to the file you wish to search. 

## Options
Short | Long | Description | Default
---- | ---- | ---- | ----
`-a` | `--all`/`--no-all` | Prints all lines. | false
`-t` | `--tagged`/`--no-tagged` | Tags the lines with query results with the position(s) of the query in each line. | false
`-i` | `--insensitive`/`--no-insensitive` | Enables case insensitive search. | false
`-c` | `--color <color>` | Sets the highlight color for found query [yellow|red|blue|green|white]. | yellow
`-h` | `--help` | Show help information. | 
