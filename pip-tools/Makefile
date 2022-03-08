# v1.3.2
#
# This Makefile automates Python pip-tools related tasks.
# Commands
#
# - `make init` - Create virtual environment (if not already in one) and install all locked dependencies.
# - `make pip-compile` - Generated updated requirements lock files after making a change to an .in file.
# - `make pip-sync` - Install/upgrade/remove packages from virtual environment to match lock files.
# - `make pip-upgrade` - Upgrade package versions in the lockfiles to the latest permissible by the .in file constraints.
#                        Use without a parameter to upgrade all packages:  `make pip-upgrade`
#                        To upgrade just a specific package: `make pip-upgrade package=the-package-name`
# - `make bootstrap` - Create a skeleton dev-requirements.in/.txt and requirements.in/.txt and virtual environment.
#                      Use this command when setting up new projects.
# - `make bootstrap-lib` - Create a skeleton dev-requirements.in/.txt and flexible requirements.txt for library projects.

# If VIRTUAL_ENV is defined, then we are currently running in the virtual environment AND this var
# is the path to the root of the virtual environment. In this case we use the active virtual environment.
# Otherwise, the default will be .venv/ in the project's directory.
ifdef VIRTUAL_ENV
	VENV_DIR = $(VIRTUAL_ENV)
else
	VENV_DIR = .venv
endif

ifeq ($(package),)
	UPGRADE_ARG = --upgrade
else
	UPGRADE_ARG = --upgrade-package $(package)
endif

VENV_BIN = $(VENV_DIR)/bin
PIP_COMPILE = CUSTOM_COMPILE_COMMAND="make pip-compile" $(VENV_BIN)/pip-compile --no-emit-index-url

ifndef VIRTUAL_ENV
define create_venv =
	rm -rf $(VENV_DIR)
	python -m venv $(VENV_DIR)
endef
else
define create_venv =
	echo "Using current ambient virtual environment"
endef
endif

define init_venv =
	$(create_venv)
	$(VENV_BIN)/pip install --upgrade pip setuptools wheel
endef

define pip_compile_all =
	(test -s requirements.in && $(PIP_COMPILE)) || { echo "requirements.in does not exist. Assuming this project is a library. "; true; }
	$(PIP_COMPILE) dev-requirements.in
endef

define pip_sync =
	if [ -f requirements.in ] ; then \
		$(VENV_BIN)/pip-sync requirements.txt dev-requirements.txt ;\
	else \
		$(VENV_BIN)/pip-sync dev-requirements.txt ;\
	fi
endef

# Initialize a new virtual environment and install all locked dependencies.
# Run this whenever you first clone the repo, or if you want to start with a fresh virtual environment.
# If you have a preference for virtual environment location or style, first create it and active it
# however you like to do that, and it will be used.
# Otherwise one will be created for you at .venv/ sub-directory within the project's directory.
init:
	$(init_venv)
	$(VENV_BIN)/pip install --no-deps -r requirements.txt -r dev-requirements.txt

# Update your virtual environment to exactly match the locked dependencies.
pip-sync:
	$(pip_sync)

# Generate requirements lock files. Run this whenever you change any of the *requirements.in files.
# Note: The order matters here. In particular, the dev-requirements.in needs to be last so that it
# can constrain properly to the generated requirements.txt lockfiles.
pip-compile:
	$(pip_compile_all)

# Upgrade package versions in the lockfile to the latest permissible by the .in file constraints.
# Use without a parameter to upgrade all packages:  `make pip-upgrade`
# To upgrade just a specific package: `make pip-upgrade package=the-package-name`
pip-upgrade:
	$(PIP_COMPILE) $(UPGRADE_ARG)
	$(PIP_COMPILE) $(UPGRADE_ARG) dev-requirements.in


define BOOTSTRAP_DEV_REQUIREMENTS_IN
# Constrain all dev-requirements to the deployed application locked requirements so that your tests run with the exact
# same bits that get deployed.
-c requirements.txt

# Add your dev/test requirements below.
endef
export BOOTSTRAP_DEV_REQUIREMENTS_IN

define BOOTSTRAP_DEFAULT_DEV_REQUIREMENTS_PACKAGES
coverage
pip-tools
pytest
pytest-cov
endef
export BOOTSTRAP_DEFAULT_DEV_REQUIREMENTS_PACKAGES

define BOOTSTRAP_REQUIREMENTS_IN
# Top-level dependencies directly used by the project in _deployment_.
# Please use PEP-440 "compatible release" version markers in the form: `library~=M.mm`.  Omit the patch version.
# Actual resolved versions are in requirements.txt which is auto-generated from pip-tools.
# Example:
# boto3~=1.21
endef
export BOOTSTRAP_REQUIREMENTS_IN

define bootstrap_sequence =
	$(init_venv)
	$(VENV_BIN)/pip install pip-tools
	$(pip_compile_all)
	$(pip_sync)
endef

# Create a skeleton dev-requirements.in/.txt and requirements.in/.txt and virtual environment ready to use.
bootstrap:
	test ! -s dev-requirements.in || { echo "dev-requirements.in already exists! Stopping."; false; }
	test ! -s requirements.in || { echo "requirements.in already exists! Stopping."; false; }
	echo "$$BOOTSTRAP_DEV_REQUIREMENTS_IN" > dev-requirements.in
	echo "$$BOOTSTRAP_DEFAULT_DEV_REQUIREMENTS_PACKAGES" >> dev-requirements.in
	echo "$$BOOTSTRAP_REQUIREMENTS_IN" > requirements.in
	$(bootstrap_sequence)

define BOOTSTRAP_LIB_DEV_REQUIREMENTS_IN
# Import all library dependencies.  Since this project is a library, we do not generate lockfiles for the release,
# only for dev/test so that we can achieve repeatable builds and avoid "Works on My Machine" scenarios.
-r requirements.txt

# Add your dev/test requirements below.
endef
export BOOTSTRAP_LIB_DEV_REQUIREMENTS_IN

define BOOTSTRAP_LIB_REQUIREMENTS_TXT
# Top-level dependencies directly used by the library.
# Please use PEP-440 "compatible release" version markers in the form: `library~=M.mm`.  Omit the patch version.
# Since this project is a library there is no corresponding lock file. That is left up to the integrating application.
# Please express only what is needed by the library and to be as flexible as possible.
# Example:
# boto3~=1.21
endef
export BOOTSTRAP_LIB_REQUIREMENTS_TXT

bootstrap-lib:
	test ! -s dev-requirements.in || { echo "dev-requirements.in already exists! Stopping."; false; }
	echo "$$BOOTSTRAP_LIB_DEV_REQUIREMENTS_IN" > dev-requirements.in
	echo "$$BOOTSTRAP_DEFAULT_DEV_REQUIREMENTS_PACKAGES" >> dev-requirements.in
	echo "$$BOOTSTRAP_LIB_REQUIREMENTS_TXT" > requirements.txt
	$(bootstrap_sequence)