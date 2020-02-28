#
# Cookbook:: scrapyd-deploy
# Recipe:: python
#
# Copyright:: 2018, The Authors, All Rights Reserved.

pyenv_system_install 'system'
pyenv_python '3.6.5'
pyenv_global '3.6.5'
pyenv_rehash 'rehash'
