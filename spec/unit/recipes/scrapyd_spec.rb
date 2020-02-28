#
# Cookbook:: scrapyd-deploy
# Spec:: scrapyd
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

writable_dirs = [
  '/var/lib/scrapyd/eggs', '/var/lib/scrapyd/dbs', '/var/lib/scrapyd/items',
  '/var/log/scrapyd', '/var/run/scrapyd'
]
run_user = 'scrapy'
run_group = 'scrapy'
conf_dir = '/etc/scrapyd'
dependencies_upgrade_path = File.join(conf_dir, 'dependencies_upgrade.sh')
scrapyd_config = File.join(conf_dir, 'scrapyd.conf')

describe 'scrapyd-deploy::scrapyd' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:runner) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') }
    let(:chef_run) { runner.converge(described_recipe) }
    let(:node) { runner.node }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'should update apt' do
      expect(chef_run).to update_apt_update('Update Apt')
    end

    writable_dirs.each do |writable_dir|
      it "should create writable directory #{writable_dir}" do
        expect(chef_run).to create_directory(writable_dir).with(
          user: run_user, group: run_group, recursive: true, mode: '0755')
      end
    end

    it "should create configuration directory #{conf_dir}" do
      expect(chef_run).to create_directory(conf_dir).with(
        user: 'root', group: 'root', mode: '0755')
    end

    it "should create configuration #{scrapyd_config}" do
      expect(chef_run).to create_template(scrapyd_config).with(
        user: 'root', group: 'root', mode: '0644')
    end

    it "should create denpendencies upgrade file #{dependencies_upgrade_path}" do
      expect(chef_run).to create_template(dependencies_upgrade_path).with(
        user: 'root', group: 'root', mode: '0755')
    end

    it "creates cron 'Dependencies Upgrade'" do
      expect(chef_run).to create_cron('Dependencies Upgrade').with(
        minute: '1', user: 'root',
        command: dependencies_upgrade_path)
    end

    it "installs devpi-client" do
      expect(chef_run).to install_pyenv_pip('devpi-client')
    end

    # it "installs scrapyd" do
    #   expect(chef_run).to install_pyenv_pip('scrapyd')
    # end

    it "does rehash" do
      expect(chef_run).to run_pyenv_rehash('system')
    end

    it "runs pyenv script" do
      expect(chef_run).to run_pyenv_script('Dependencies Install').with(
        code: dependencies_upgrade_path, user: 'root')
    end

    it "does rehash" do
      expect(chef_run).to run_pyenv_rehash('system')
    end

    it "should create systemd service scrapyd.service" do
      expect(chef_run).to create_systemd_unit('scrapyd.service').with(
        action: [:create, :enable, :start])
    end
  end
end
