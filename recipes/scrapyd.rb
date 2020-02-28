#
# Cookbook:: scrapyd-deploy
# Recipe:: scrapyd
#
# Copyright:: 2020, The Authors, All Rights Reserved.

include_recipe 'scrapyd-deploy::user'
include_recipe 'scrapyd-deploy::python'

run_dir = '/var/run/scrapyd'
config_dir = '/etc/scrapyd'
scrapyd_config = File.join(config_dir, 'scrapyd.conf')
dependencies_upgrade_path = File.join(config_dir, 'dependencies_upgrade.sh')
pidfile = File.join(run_dir, 'scrapyd.pid')

apt_update 'Update Apt' do
  action :update
end

[
  node['scrapyd']['eggs_dir'], node['scrapyd']['dbs_dir'], node['scrapyd']['items_dir'],
  node['scrapyd']['logs_dir'], run_dir
].each do |writable_dir|
  directory writable_dir do
    owner node['scrapyd']['user']
    group node['scrapyd']['group']
    recursive true
    mode '0755'
  end
end

directory config_dir do
  owner 'root'
  group 'root'
  mode '0755'
end

template scrapyd_config do
  source 'scrapyd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Dependencies upgrade
template dependencies_upgrade_path do
  source 'dependencies_upgrade.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

cron 'Dependencies Upgrade' do
    minute '1'
    user 'root'
    command dependencies_upgrade_path
end

# Install devpi, scrapyd and dependencies
pyenv_pip 'devpi-client'
pyenv_rehash 'system'

pyenv_script 'Dependencies Install' do
  code dependencies_upgrade_path
  user 'root'
end
pyenv_rehash 'system'

systemd_unit 'scrapyd.service' do
  content({
    Unit: {
      Description: 'Scrapyd',
      After: 'network.target'
    },
    Service: {
      User: node['scrapyd']['user'],
      Group: node['scrapyd']['group'],
      RuntimeDirectory: 'scrapyd',
      ExecStart: "/usr/local/pyenv/shims/scrapyd -l #{node['scrapyd']['logs_dir']}/scrapyd.log --pidfile #{pidfile}",
      PIDFile: "#{pidfile}",
      Restart: 'always'
    },
    Install: {
      WantedBy: 'multi-user.target'
    }
  })

  action [:create, :enable, :start]
end
