# Makefile for automating Python pip-tools related tasks.

This Makefile is meant to simplify package management when using pip-tools in a project.
It supports version locking best-practices for top-level applications (eg jobs, lambdas, CLI) as well as libraries.

By using this Makefile, you don't have to remember when to use '-r requirements.txt' vs '-c requirements.txt' and
when to generate lock files and when not to, and what order to execute pip-compiles, among other subtle things.

## Commands
- `make init` - Create virtual environment (if not already in one) and install all locked dependencies.
- `make pip-compile` - Generated updated requirements lock files after making a change to an .in file.
- `make pip-sync` - Install/upgrade/remove packages from virtual environment to match lock files.
- `make pip-upgrade` - Upgrade package versions in the lockfiles to the latest permissible by the .in file constraints.
                       Use without a parameter to upgrade all packages:  `make pip-upgrade`
                       To upgrade just a specific package: `make pip-upgrade package=the-package-name`
- `make bootstrap` - Create a skeleton dev-requirements.in/.txt and requirements.in/.txt and virtual environment.
                     Use this command when setting up new top-level application projects.
- `make bootstrap-lib` - Create a skeleton dev-requirements.in/.txt and flexible requirements.txt for library projects.

## Adding to your project
Simply copy into your project source:
`wget https://raw.githubusercontent.com/upside-services/python-setup-scripts/master/pip-tools/Makefile`