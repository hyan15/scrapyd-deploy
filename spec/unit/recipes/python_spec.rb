#
# Cookbook:: scrapyd-deploy
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'scrapyd-deploy::python' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:runner) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') }
    let(:chef_run) { runner.converge(described_recipe) }
    let(:node) { runner.node }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'should install system pyenv' do
      expect(chef_run).to install_pyenv_system_install('system')
    end

    it 'should install system python 3.6.5' do
      expect(chef_run).to install_pyenv_python('3.6.5')
    end

    it 'should create pyenv global 3.6.5' do
      expect(chef_run).to create_pyenv_global('3.6.5')
    end

    it 'should run rehash' do
      expect(chef_run).to run_pyenv_rehash('rehash')
    end
  end
end
