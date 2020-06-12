# Docker image for `file-lint`

[![Build Status](https://travis-ci.com/cytopia/docker-file-lint.svg?branch=master)](https://travis-ci.com/cytopia/docker-file-lint)
[![Tag](https://img.shields.io/github/tag/cytopia/docker-file-lint.svg)](https://github.com/cytopia/docker-file-lint/releases)
[![](https://images.microbadger.com/badges/version/cytopia/file-lint:latest.svg?&kill_cache=1)](https://microbadger.com/images/cytopia/file-lint:latest "file-lint")
[![](https://images.microbadger.com/badges/image/cytopia/file-lint:latest.svg?&kill_cache=1)](https://microbadger.com/images/cytopia/file-lint:latest "file-lint")
[![](https://img.shields.io/docker/pulls/cytopia/file-lint.svg)](https://hub.docker.com/r/cytopia/file-lint)
[![](https://img.shields.io/badge/github-cytopia%2Fdocker--file--lint-red.svg)](https://github.com/cytopia/docker-file-lint "github.com/cytopia/docker-file-lint")
[![License](https://img.shields.io/badge/license-MIT-%233DA639.svg)](https://opensource.org/licenses/MIT)

> #### All [#awesome-ci](https://github.com/topics/awesome-ci) Docker images
>
> [ansible][ansible-git-lnk] **•**
> [ansible-lint][alint-git-lnk] **•**
> [awesome-ci][aci-git-lnk] **•**
> [black][black-git-lnk] **•**
> [checkmake][cm-git-lnk] **•**
> [eslint][elint-git-lnk] **•**
> [file-lint][flint-git-lnk] **•**
> [gofmt][gfmt-git-lnk] **•**
> [goimports][gimp-git-lnk] **•**
> [golint][glint-git-lnk] **•**
> [jsonlint][jlint-git-lnk] **•**
> [phpcbf][pcbf-git-lnk] **•**
> [phpcs][pcs-git-lnk] **•**
> [phplint][plint-git-lnk] **•**
> [php-cs-fixer][pcsf-git-lnk] **•**
> [pycodestyle][pycs-git-lnk] **•**
> [pylint][pylint-git-lnk] **•**
> [terraform-docs][tfdocs-git-lnk] **•**
> [terragrunt][tg-git-lnk] **•**
> [terragrunt-fmt][tgfmt-git-lnk] **•**
> [yamlfmt][yfmt-git-lnk] **•**
> [yamllint][ylint-git-lnk]

> #### All [#awesome-ci](https://github.com/topics/awesome-ci) Makefiles
>
> Visit **[cytopia/makefiles](https://github.com/cytopia/makefiles)** for seamless project integration, minimum required best-practice code linting and CI.

View **[Dockerfile](https://github.com/cytopia/docker-file-lint/blob/master/Dockerfile)** on GitHub.

[![Docker hub](http://dockeri.co/image/cytopia/file-lint?&kill_cache=1)](https://hub.docker.com/r/cytopia/file-lint)


Tiny Alpine-based Docker image for the very basics of CI against your code files based one [awesome-ci](https://github.com/topics/awesome-ci)<sup>[1]</sup>.

<sup>[1] Original project: https://github.com/topics/awesome-ci</sup>


## Features

### Overview
* dry run (which shows all piped unix command voodoo for learning)
* project based configuration file (`awesome-ci.conf`)
* check for empty files
* check for files with carriage returns (`\r`)
* check for files with windows newlines (`\r\n`)
* check for files with nullbyte characters (`\x00`)
* check for trailing newlines at eof (exactly one or multiple)
* check for trailing white space
* ensure files are utf8 encoded
* ensure files do not contain utf8 bom (byte order mark: `U+FEFF`)
* allows for automatic fixing (most commands)
* allows for find-grained control
    - check files by specific extension(s) only
    - check files by specific shebang only
    - check binary or text-files only

### Tools
| Type | Tool | Fixable | Description |
|------|------|---------|-------------|
| File | [file-cr](data/file-cr) | ✓ | Scan files and check if they contain CR (Carriage Return only). |
| File | [file-crlf](data/file-crlf) | ✓ | Scan files and check if they contain CRLF (Windows Line Feeds). |
| File | [file-empty](data/file-empty) | | Scan files and check if they are empty (0 bytes). |
| File | [file-nullbyte](data/file-nullbyte) | ✓ | Scan files and check if they contain a null-byte character (`\x00)`. |
| File | [file-trailing-newline](data/file-trailing-newline) | ✓ | Scan files and check if they contain a trailing newline. |
| File | [file-trailing-single-newline](data/file-trailing-single-newline) | ✓ | Scan files and check if they contain exactly one trailing newline. |
| File | [file-trailing-space](data/file-trailing-space) | ✓ | Scan files and check if they contain trailing whitespaces. |
| File | [file-utf8](data/file-utf8) | ✓ | Scan files and check if they have a non UTF-8 encoding. |
| File | [file-utf8-bom](data/file-utf8-bom) | ✓ | Scan files and check if they contain BOM (Byte Order Mark): `U+FEFF`. |
| Git  | [git-conflicts](data/git-conflicts) | x | Scan files and check if they contain git conflicts. |

> <sub>Tools extracted from https://github.com/cytopia/awesome-ci</sub>


## Available Docker image versions

| Docker tag | Build from |
|------------|------------|
| `latest`   | Current stable file-lint version |
| `<tag>`    | Git tag from this repository     |


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
# git-conflicts                 Scans if files contain git conflicts           #
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

# file-nullbyte
FILE_NULLBYTE_EXTENSION=""
FILE_NULLBYTE_IGNORE=".git,*.svn,*.pyc"
FILE_NULLBYTE_TEXT=1
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

# git-conflicts
GIT_CONFLICTS_EXTENSION=""
GIT_CONFLICTS_IGNORE=".git,*.svn"
GIT_CONFLICTS_TEXT=1
GIT_CONFLICTS_SIZE=1
```

### Example Makefile
```make
ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: lint _lint-cr _lint-crlf _lint-trailing-single-newline _lint-trailing-space _lint-utf8 _lint-utf8-bom

CURRENT_DIR = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

FL_VERSION      = latest
FL_IGNORE_PATHS = .git/,.github/

lint:
	@$(MAKE) --no-print-directory _lint-cr
	@$(MAKE) --no-print-directory _lint-crlf
	@$(MAKE) --no-print-directory _lint-trailing-single-newline
	@$(MAKE) --no-print-directory _lint-trailing-space
	@$(MAKE) --no-print-directory _lint-utf8
	@$(MAKE) --no-print-directory _lint-utf8-bom

_lint-cr:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint:$(FL_VERSION) file-cr --text --ignore '$(FL_IGNORE_PATHS)' --path .

_lint-crlf:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint:$(FL_VERSION) file-crlf --text --ignore '$(FL_IGNORE_PATHS)' --path .

_lint-trailing-single-newline:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint:$(FL_VERSION) file-trailing-single-newline --text --ignore '$(FL_IGNORE_PATHS)' --path .

_lint-trailing-space:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint:$(FL_VERSION) file-trailing-space --text --ignore '$(FL_IGNORE_PATHS)' --path .

_lint-utf8:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint:$(FL_VERSION) file-utf8 --text --ignore '$(FL_IGNORE_PATHS)' --path .

_lint-utf8-bom:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint:$(FL_VERSION) file-utf8-bom --text --ignore '$(FL_IGNORE_PATHS)' --path .
```


## Related [#awesome-ci](https://github.com/topics/awesome-ci) projects

### Docker images

Save yourself from installing lot's of dependencies and pick a dockerized version of your favourite
linter below for reproducible local or remote CI tests:

| GitHub | DockerHub | Type | Description |
|--------|-----------|------|-------------|
| [awesome-ci][aci-git-lnk]        | [![aci-hub-img]][aci-hub-lnk]         | Basic      | Tools for git, file and static source code analysis |
| [file-lint][flint-git-lnk]       | [![flint-hub-img]][flint-hub-lnk]     | Basic      | Baisc source code analysis |
| [ansible][ansible-git-lnk]       | [![ansible-hub-img]][ansible-hub-lnk] | Ansible    | Multiple versions and flavours of Ansible |
| [ansible-lint][alint-git-lnk]    | [![alint-hub-img]][alint-hub-lnk]     | Ansible    | Lint Ansible |
| [gofmt][gfmt-git-lnk]            | [![gfmt-hub-img]][gfmt-hub-lnk]       | Go         | Format Go source code **<sup>[1]</sup>** |
| [goimports][gimp-git-lnk]        | [![gimp-hub-img]][gimp-hub-lnk]       | Go         | Format Go source code **<sup>[1]</sup>** |
| [golint][glint-git-lnk]          | [![glint-hub-img]][glint-hub-lnk]     | Go         | Lint Go code |
| [eslint][elint-git-lnk]          | [![elint-hub-img]][elint-hub-lnk]     | Javascript | Lint Javascript code |
| [jsonlint][jlint-git-lnk]        | [![jlint-hub-img]][jlint-hub-lnk]     | JSON       | Lint JSON files **<sup>[1]</sup>** |
| [checkmake][cm-git-lnk]          | [![cm-hub-img]][cm-hub-lnk]           | Make       | Lint Makefiles |
| [phpcbf][pcbf-git-lnk]           | [![pcbf-hub-img]][pcbf-hub-lnk]       | PHP        | PHP Code Beautifier and Fixer |
| [phpcs][pcs-git-lnk]             | [![pcs-hub-img]][pcs-hub-lnk]         | PHP        | PHP Code Sniffer |
| [phplint][plint-git-lnk]         | [![plint-hub-img]][plint-hub-lnk]     | PHP        | PHP Code Linter **<sup>[1]</sup>** |
| [php-cs-fixer][pcsf-git-lnk]     | [![pcsf-hub-img]][pcsf-hub-lnk]       | PHP        | PHP Coding Standards Fixer |
| [black][black-git-lnk]           | [![black-hub-img]][black-hub-lnk]     | Python     | The uncompromising Python code formatter |
| [pycodestyle][pycs-git-lnk]      | [![pycs-hub-img]][pycs-hub-lnk]       | Python     | Python style guide checker |
| [pylint][pylint-git-lnk]         | [![pylint-hub-img]][pylint-hub-lnk]   | Python     | Python source code, bug and quality checker |
| [terraform-docs][tfdocs-git-lnk] | [![tfdocs-hub-img]][tfdocs-hub-lnk]   | Terraform  | Terraform doc generator (TF 0.12 ready) **<sup>[1]</sup>** |
| [terragrunt][tg-git-lnk]         | [![tg-hub-img]][tg-hub-lnk]           | Terraform  | Terragrunt and Terraform |
| [terragrunt-fmt][tgfmt-git-lnk]  | [![tgfmt-hub-img]][tgfmt-hub-lnk]     | Terraform  | `terraform fmt` for Terragrunt files **<sup>[1]</sup>** |
| [yamlfmt][yfmt-git-lnk]          | [![yfmt-hub-img]][yfmt-hub-lnk]       | Yaml       | Format Yaml files **<sup>[1]</sup>** |
| [yamllint][ylint-git-lnk]        | [![ylint-hub-img]][ylint-hub-lnk]     | Yaml       | Lint Yaml files |

> **<sup>[1]</sup>** Uses a shell wrapper to add **enhanced functionality** not available by original project.

[aci-git-lnk]: https://github.com/cytopia/awesome-ci
[aci-hub-img]: https://img.shields.io/docker/pulls/cytopia/awesome-ci.svg
[aci-hub-lnk]: https://hub.docker.com/r/cytopia/awesome-ci

[flint-git-lnk]: https://github.com/cytopia/docker-file-lint
[flint-hub-img]: https://img.shields.io/docker/pulls/cytopia/file-lint.svg
[flint-hub-lnk]: https://hub.docker.com/r/cytopia/file-lint

[jlint-git-lnk]: https://github.com/cytopia/docker-jsonlint
[jlint-hub-img]: https://img.shields.io/docker/pulls/cytopia/jsonlint.svg
[jlint-hub-lnk]: https://hub.docker.com/r/cytopia/jsonlint

[ansible-git-lnk]: https://github.com/cytopia/docker-ansible
[ansible-hub-img]: https://img.shields.io/docker/pulls/cytopia/ansible.svg
[ansible-hub-lnk]: https://hub.docker.com/r/cytopia/ansible

[alint-git-lnk]: https://github.com/cytopia/docker-ansible-lint
[alint-hub-img]: https://img.shields.io/docker/pulls/cytopia/ansible-lint.svg
[alint-hub-lnk]: https://hub.docker.com/r/cytopia/ansible-lint

[gfmt-git-lnk]: https://github.com/cytopia/docker-gofmt
[gfmt-hub-img]: https://img.shields.io/docker/pulls/cytopia/gofmt.svg
[gfmt-hub-lnk]: https://hub.docker.com/r/cytopia/gofmt

[gimp-git-lnk]: https://github.com/cytopia/docker-goimports
[gimp-hub-img]: https://img.shields.io/docker/pulls/cytopia/goimports.svg
[gimp-hub-lnk]: https://hub.docker.com/r/cytopia/goimports

[glint-git-lnk]: https://github.com/cytopia/docker-golint
[glint-hub-img]: https://img.shields.io/docker/pulls/cytopia/golint.svg
[glint-hub-lnk]: https://hub.docker.com/r/cytopia/golint

[elint-git-lnk]: https://github.com/cytopia/docker-eslint
[elint-hub-img]: https://img.shields.io/docker/pulls/cytopia/eslint.svg
[elint-hub-lnk]: https://hub.docker.com/r/cytopia/eslint

[cm-git-lnk]: https://github.com/cytopia/docker-checkmake
[cm-hub-img]: https://img.shields.io/docker/pulls/cytopia/checkmake.svg
[cm-hub-lnk]: https://hub.docker.com/r/cytopia/checkmake

[pcbf-git-lnk]: https://github.com/cytopia/docker-phpcbf
[pcbf-hub-img]: https://img.shields.io/docker/pulls/cytopia/phpcbf.svg
[pcbf-hub-lnk]: https://hub.docker.com/r/cytopia/phpcbf

[pcs-git-lnk]: https://github.com/cytopia/docker-phpcs
[pcs-hub-img]: https://img.shields.io/docker/pulls/cytopia/phpcs.svg
[pcs-hub-lnk]: https://hub.docker.com/r/cytopia/phpcs

[plint-git-lnk]: https://github.com/cytopia/docker-phplint
[plint-hub-img]: https://img.shields.io/docker/pulls/cytopia/phplint.svg
[plint-hub-lnk]: https://hub.docker.com/r/cytopia/phplint

[pcsf-git-lnk]: https://github.com/cytopia/docker-php-cs-fixer
[pcsf-hub-img]: https://img.shields.io/docker/pulls/cytopia/php-cs-fixer.svg
[pcsf-hub-lnk]: https://hub.docker.com/r/cytopia/php-cs-fixer

[black-git-lnk]: https://github.com/cytopia/docker-black
[black-hub-img]: https://img.shields.io/docker/pulls/cytopia/black.svg
[black-hub-lnk]: https://hub.docker.com/r/cytopia/black

[pycs-git-lnk]: https://github.com/cytopia/docker-pycodestyle
[pycs-hub-img]: https://img.shields.io/docker/pulls/cytopia/pycodestyle.svg
[pycs-hub-lnk]: https://hub.docker.com/r/cytopia/pycodestyle

[pylint-git-lnk]: https://github.com/cytopia/docker-pylint
[pylint-hub-img]: https://img.shields.io/docker/pulls/cytopia/pylint.svg
[pylint-hub-lnk]: https://hub.docker.com/r/cytopia/pylint

[tfdocs-git-lnk]: https://github.com/cytopia/docker-terraform-docs
[tfdocs-hub-img]: https://img.shields.io/docker/pulls/cytopia/terraform-docs.svg
[tfdocs-hub-lnk]: https://hub.docker.com/r/cytopia/terraform-docs

[tg-git-lnk]: https://github.com/cytopia/docker-terragrunt
[tg-hub-img]: https://img.shields.io/docker/pulls/cytopia/terragrunt.svg
[tg-hub-lnk]: https://hub.docker.com/r/cytopia/terragrunt

[tgfmt-git-lnk]: https://github.com/cytopia/docker-terragrunt-fmt
[tgfmt-hub-img]: https://img.shields.io/docker/pulls/cytopia/terragrunt-fmt.svg
[tgfmt-hub-lnk]: https://hub.docker.com/r/cytopia/terragrunt-fmt

[yfmt-git-lnk]: https://github.com/cytopia/docker-yamlfmt
[yfmt-hub-img]: https://img.shields.io/docker/pulls/cytopia/yamlfmt.svg
[yfmt-hub-lnk]: https://hub.docker.com/r/cytopia/yamlfmt

[ylint-git-lnk]: https://github.com/cytopia/docker-yamllint
[ylint-hub-img]: https://img.shields.io/docker/pulls/cytopia/yamllint.svg
[ylint-hub-lnk]: https://hub.docker.com/r/cytopia/yamllint


### Makefiles

Visit **[cytopia/makefiles](https://github.com/cytopia/makefiles)** for dependency-less, seamless project integration and minimum required best-practice code linting for CI.
The provided Makefiles will only require GNU Make and Docker itself removing the need to install anything else.


## License

**[MIT License](LICENSE)**

Copyright (c) 2019 [cytopia](https://github.com/cytopia)
