#!/usr/bin/env python3
"""
This script configures Poetry for use with a private repository.
It parses the PIP_INDEX environment variable to extract the username, password, and url, and
then invokes `poetry config` to set the values.
This is useful in Dockerfiles when there is an existing PIP_INDEX arg and you wish to use Poetry with a private
repository.

Usage:
    pip-index-to-poetry-config.py {repo-name}

Set {repo-name} to match the name of the repository used in pyproject.toml tool.poetry.source.name
"""

import os
import sys
from urllib.parse import urlparse, urlunparse

poetry_repository_name = sys.argv[1]
pip_index = os.environ.get('PIP_INDEX')

pip_index_parsed = urlparse(pip_index)
poetry_repository_url = urlunparse(pip_index_parsed._replace(netloc=pip_index_parsed.hostname))

os.system(f'poetry config repositories.{poetry_repository_name} {poetry_repository_url}')
os.system(f'poetry config http-basic.{poetry_repository_name} {pip_index_parsed.username} {pip_index_parsed.password}')