#
# Cookbook:: scrapyd-deploy
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'scrapyd-deploy::python'
include_recipe 'scrapyd-deploy::user'


eggs_dir = '/var/lib/scrapyd/eggs'
dbs_dir = '/var/lib/scrapyd/dbs'
items_dir = '/var/lib/scrapyd/items'
logs_dir = '/var/log/scrapyd'
run_dir = '/var/run/scrapyd'

config_dir = '/etc/scrapyd'
scrapyd_config = File.join(config_dir, 'scrapyd.conf')
dependencies_dir = File.join(config_dir, 'dependencies')
requirements_path = File.join(dependencies_dir, 'requirements.txt')
pidfile = File.join(run_dir, 'scrapyd.pid')

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

directory dependencies_dir do
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

template requirements_path do
  source 'requirements.txt.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

cron "Dependencies Upgrade" do
  minute '11'
  hour '1'
  user 'root'
  command "pip install -U -r #{requirements_path}"
end

systemd_unit 'scrapyd.service' do
  content({
    Unit: {
      Description: 'Scrapyd',
      After: 'network.target'
    },
    Service: {
      User: node['scrapyd']['user'],
      Group: node['scrapyd']['group'],
      ExecStart: "/usr/bin/env scrapyd -l #{logs_dir}/scrapyd.log --pidfile #{pidfile}",
      PIDFile: "#{pidfile}",
      Restart: 'always'
    },
    Install: {
      WantedBy: 'multi-user.target'
    }
  })

  action [:create, :enable, :start]
end
