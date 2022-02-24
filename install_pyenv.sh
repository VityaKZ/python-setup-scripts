#!/bin/bash
# To execute this from a command prompt:
# curl https://raw.githubusercontent.com/upside-services/python-setup-scripts/master/install_pyenv.sh | bash

# Set bash as the default shell.
chsh -s /bin/bash

# Install pyenv
curl https://pyenv.run | bash

# Add pyenv to path
# If this issue (https://github.com/pyenv/pyenv-installer/issues/112) is ever implemented we can hopefully remove this
# manual addition.
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init --path)"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.profile

# Add the pyenv-alias-latest-patch-version so we can reference minor versions without specific patch versions
git clone https://github.com/upside-services/pyenv-alias-latest-patch-version.git $(pyenv root)/plugins/pyenv-alias-latest-patch-version

# Install all the versions we want
pyenv install 3.6:latest
pyenv install 3.7:latest
pyenv install 3.8:latest
pyenv install 3.9:latest

# Set the default version to 3.6
# This lets 3.6 be ambient for projects that don't yet have .python-version.
pyenv global 3.6
