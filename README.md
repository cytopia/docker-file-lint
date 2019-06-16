# Docker image for `file-lint`

[![Build Status](https://travis-ci.com/cytopia/docker-file-lint.svg?branch=master)](https://travis-ci.com/cytopia/docker-file-lint)
[![Tag](https://img.shields.io/github/tag/cytopia/docker-file-lint.svg)](https://github.com/cytopia/docker-file-lint/releases)
[![](https://images.microbadger.com/badges/version/cytopia/file-lint:latest.svg)](https://microbadger.com/images/cytopia/file-lint:latest "file-lint")
[![](https://images.microbadger.com/badges/image/cytopia/file-lint:latest.svg)](https://microbadger.com/images/cytopia/file-lint:latest "file-lint")
[![](https://img.shields.io/badge/github-cytopia%2Fdocker--file--lint-red.svg)](https://github.com/cytopia/docker-file-lint "github.com/cytopia/docker-file-lint")
[![License](https://img.shields.io/badge/license-MIT-%233DA639.svg)](https://opensource.org/licenses/MIT)

> #### All awesome CI images
>
> [ansible](https://github.com/cytopia/docker-ansible) |
> [ansible-lint](https://github.com/cytopia/docker-ansible-lint) |
> [awesome-ci](https://github.com/cytopia/awesome-ci) |
> [eslint](https://github.com/cytopia/docker-eslint) |
> [file-lint](https://github.com/cytopia/docker-file-lint) |
> [jsonlint](https://github.com/cytopia/docker-jsonlint) |
> [pycodestyle](https://github.com/cytopia/docker-pycodestyle) |
> [terraform-docs](https://github.com/cytopia/docker-terraform-docs) |
> [yamllint](https://github.com/cytopia/docker-yamllint)


View **[Dockerfile](https://github.com/cytopia/docker-file-lint/blob/master/Dockerfile)** on GitHub.

[![Docker hub](http://dockeri.co/image/cytopia/file-lint)](https://hub.docker.com/r/cytopia/file-lint)


Tiny Alpine-based Docker image for the very basics of CI against your code files based one [awesome-ci](https://github.com/topics/awesome-ci)<sup>[1]</sup>.

<sup>[1] Original project: https://github.com/topics/awesome-ci</sup>


## Features

* dry run (which shows all piped unix command voodoo for learning)
* project based configuration file (`awesome-ci.conf`)
* check for empty files
* check for files with carriage returns (`\r`)
* check for files with windows newlines (`\r\n`)
* check for files with nullbyte characters (`\x00`)
* check for trailing newlines (exactly one or multiple) at eof
* check for trailing whitespace space
* ensure files are utf8 encoded
* ensure files do not contain byte order mark
* allows for automatic fixing (most commands)
* allows for find-grained control
    - check files by specific extension(s) only
    - check files by specific shebang only
    - check binary or text-files only


## Available Docker image versions

| Docker tag | Build from |
|------------|------------|
| `latest`   | Current stable file-lint version |


## Docker mounts

The working directory inside the Docker container is **`/data/`** and should be mounted locally.


## Usage

### General
```bash
$ docker run --rm -v $(pwd):/data cytopia/file-lint

################################################################################
#                              cytopia/file-lint                               #
#                                 (awesome-ci)                                 #
################################################################################
#                                                                              #
#                                                                              #
# Usage:                                                                       #
# -----------------------------------------------------------------------------#
# docker run --rm cytopia/file-lint --help                                     #
# docker run --rm cytopia/file-lint <tool> --help                              #
# docker run --rm cytopia/file-lint <tool> --info                              #
# docker run --rm cytopia/file-lint <tool> --version                           #
#                                                                              #
#                                                                              #
# Available tools:                                                             #
# -----------------------------------------------------------------------------#
# file-empty                    Scans if files are empty                       #
# file-cr                       Scans if files contain carriage returns (\r)   #
# file-crlf                     Scans if files contain win line feeds (\r\n)   #
# file-nullbyte                 Scans if files contain nullbyte chars (\x00)   #
# file-trailing-newline         Scans if files contain trailing newline(s)     #
# file-trailing-single-newline  Scans if files contain single trailing newline #
# file-trailing-space           Scans if files contain trailing whitespace     #
# file-utf8                     Scans if files are utf8 encoded                #
# file-utf8-bom                 Scans if files contain byte order mark         #
#                                                                              #
#                                                                              #
# Example:                                                                     #
# -----------------------------------------------------------------------------#
# docker run --rm -v $(pwd):/data cytopia/file-lint \                          #
#     lf-crlf --ignore ".git/,.github/" --path .                               #
#                                                                              #
################################################################################
```

### Tool usage
The following help screen is taken from `file-crlf`. All other tools have the exact same functionality.
```
$ docker run --rm cytopia/file-lint file-crlf --help

Usage: file-crlf [--text] [--size] [--shebang <ARG>] [--extension "tpl,htm,html,php,..."] [--ignore "dir1,dir2"] [--config "conf"] [--confpre "FILE_CRLF_"] [--fix] [--verbose] [--debug] [--dry] [--list] --path <DIR>
       file-crlf --info
       file-crlf --help
       file-crlf --version

Scans recursively for files containing CRLF (Windows Line Feeds).
Will return 1 on occurance, otherwise 0.

Required arguments:

  --path <ARG>       Specify directory where to scan.


Optional run arguments:
  --fix              Fixable :-)
                     Fix the problems for the specified files.
                     Note, all other options below also apply

  --text             Limit search to text files only (non-binary).
                     Can be narrowed further with '--extension'

  --size             Limit search to files which are not empty (bigger than 0 bytes).

  --shebang <ARG>    Only find files (shell scripts) with this specific shebang.
                     It is useful to combine this with --text and --size for faster searches.
                     Use with --dry to see how this search command is generated.
                     Example:
                         --shebang bash
                         --shebang php
                         --shebang sh

  --extension <ARG>  Only find files matching those extensions.
                     Comma separated list of file extensions.
                     Only find files matching those extensions.
                     Defaults to all files if not specified or empty.
                     Example:
                         --extension "html,php,inc"
                         --extension php

  --ignore <ARG>     Comma separated list of ignore paths.
                     Directories must be specified from the starting location of --path.
                     Example:
                          ignore 'foor/bar' folder inside '/var/www' path:
                         --path /var/www --ignore foo/bar

  --config <ARG>     Load configuration file.
                     File must contain the following directives:
                         FILE_CRLF_EXTENSION="" # comma separated
                         FILE_CRLF_IGNORE=""    # comma separated
                         FILE_CRLF_TEXT=0|1     # 0 or 1
                     Note that cmd arguments take precedence over
                     config file settings.

  --confpre <ARG>    Set custom configuration directive prefix.
                     Current default ist: 'FILE_CRLF_'.
                     This is useful, when you want to define different defaults
                     per check via configuration file.

  --verbose          Be verbose and print commands and files being checked.


  --debug            Print system messages.


Optional training arguments:
  --dry              Don't do anything, just display the commands.

  --list             Instead of searching inside the files, just display the filenames
                     that would be found by --path, --extension and --ignore


System arguments:
  --info             Show versions of required commands (useful for bugreports).
  --help             Show help screen.
  --version          Show version information.


file-crlf is part of the awesome-ci collection.
https://github.com/cytopia/awesome-ci
```

### Configuration file
You can also add a configuration file named `awesome-ci.conf` to your project to configure it to your likings.
```bash
#
# Awesome-ci configuration file
#
# Each tool will have its own config section
# which all behave in the same way:
#
#
# 1. File extensions
# ------------------
# Comma separated list of file extensions
# to narrow down the files to check.
#     <TOOL_NAME>_EXTENSION=""
#     <TOOL_NAME>_EXTENSION="tpl,html"
#
# 2. Ignored paths
# ----------------
# Comma separated list of file paths
# to narrow down the files to check.
# Note that those paths must start at the
# path where --path starts.
#     <TOOL_NAME>_IGNORE=""
#     <TOOL_NAME>_IGNORE="tmp/log,tmp/run"
#
# 3. Text files
# -------------
# 0 or 1 to specify whether to work on text files
# only.
#     <TOOL_NAME>_TEXT=0
#     <TOOL_NAME>_TEXT=1




#
# File checkers
#
# file-cr
FILE_CR_EXTENSION=""
FILE_CR_IGNORE=".git,*.svn"
FILE_CR_TEXT=1
FILE_CR_SIZE=1

# file-crlf
FILE_CRLF_EXTENSION=""
FILE_CRLF_IGNORE=".git,*.svn"
FILE_CRLF_TEXT=1
FILE_CRLF_SIZE=1

# file-empty
FILE_EMPTY_EXTENSION=""
FILE_EMPTY_IGNORE=".git,*.svn"
FILE_EMPTY_TEXT=0
FILE_EMPTY_SIZE=0

# file-crlf
FILE_NULLBYTE_EXTENSION=""
FILE_NULLBYTE_IGNORE=".git,*.svn,*.pyc"
FILE_NULLBYTE_TEXT=0
FILE_NULLBYTE_SIZE=1

# file-trailing-newline
FILE_TRAILING_NEWLINE_EXTENSION=""
FILE_TRAILING_NEWLINE_IGNORE=".git,*.svn"
FILE_TRAILING_NEWLINE_TEXT=1
FILE_TRAILING_NEWLINE_SIZE=1

# file-trailing-single-newline
FILE_TRAILING_SINGLE_NEWLINE_EXTENSION=""
FILE_TRAILING_SINGLE_NEWLINE_IGNORE=".git,*.svn"
FILE_TRAILING_SINGLE_NEWLINE_TEXT=1
FILE_TRAILING_SINGLE_NEWLINE_SIZE=1

# file-trailing-space
FILE_TRAILING_SPACE_EXTENSION=""
FILE_TRAILING_SPACE_IGNORE=".git,*.svn"
FILE_TRAILING_SPACE_TEXT=1
FILE_TRAILING_SPACE_SIZE=1

# file-utf8
FILE_UTF8_EXTENSION=""
FILE_UTF8_IGNORE=".git,*.svn"
FILE_UTF8_TEXT=1
FILE_UTF8_SIZE=1

# file-utf8-bom
FILE_UTF8_BOM_EXTENSION=""
FILE_UTF8_BOM_IGNORE=".git,*.svn"
FILE_UTF8_BOM_TEXT=1
FILE_UTF8_BOM_SIZE=1
```

### Example Makefile
```make
ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: lint _lint-cr _lint-crlf _lint-trailing-single-newline _lint-trailing-space _lint-utf8 _lint-utf8-bom

CURRENT_DIR = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

lint:
	@$(MAKE) --no-print-directory _lint-cr
	@$(MAKE) --no-print-directory _lint-crlf
	@$(MAKE) --no-print-directory _lint-trailing-single-newline
	@$(MAKE) --no-print-directory _lint-trailing-space
	@$(MAKE) --no-print-directory _lint-utf8
	@$(MAKE) --no-print-directory _lint-utf8-bom

_lint-cr:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint file-cr --text --ignore '.git/,.github/' --path .

_lint-crlf:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint file-crlf --text --ignore '.git/,.github/' --path .

_lint-trailing-single-newline:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint file-trailing-single-newline --text --ignore '.git/,.github/' --path .

_lint-trailing-space:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint file-trailing-space --text --ignore '.git/,.github/' --path .

_lint-utf8:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint file-utf8 --text --ignore '.git/,.github/' --path .

_lint-utf8-bom:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint file-utf8-bom --text --ignore '.git/,.github/' --path .
```


## License

**[MIT License](LICENSE)**

Copyright (c) 2019 [cytopia](https://github.com/cytopia)
