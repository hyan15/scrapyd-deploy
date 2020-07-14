# -*- coding: utf-8 -*-

# Copyright © 2018 by IBPort. All rights reserved.
# @Author: Neal Wong
# @Email:   qwang16@olivetuniversity.edu

default['scrapyd']['packages_url'] = 'https://devpi.olivesmall.com'
default['scrapyd']['packages_index'] = '/ibprnd/prod'
default['scrapyd']['packages'] = [
  'scrapyd', 'scrapy-user-agents', 'scrapy-redis', 'scrapy-splash', 'scrapy-proxy-pool',
  'scrapy-mongodb', '"Scrapy<2"', 'deathbycaptcha', '"elasticsearch<7"', 'amazon-page-parser',
  'python-dotenv', 'sentry-sdk'
]

default['scrapyd']['user'] = 'scrapy'
default['scrapyd']['group'] = 'scrapy'
default['scrapyd']['bind_address'] = '0.0.0.0'
default['scrapyd']['http_port'] = '6800'
default['scrapyd']['http_user'] = 'ibprnd'
default['scrapyd']['http_password'] = 'ibportrnd153'
default['scrapyd']['max_proc'] = 0
default['scrapyd']['max_proc_per_cpu'] = 4
default['scrapyd']['debug'] = 'off'
default['scrapyd']['eggs_dir'] = '/var/lib/scrapyd/eggs'
default['scrapyd']['dbs_dir'] = '/var/lib/scrapyd/dbs'
default['scrapyd']['logs_dir'] = '/var/log/scrapyd'
default['scrapyd']['items_dir'] = '/var/lib/scrapyd/items'
default['scrapyd']['jobs_to_keep'] = 5
default['scrapyd']['finished_to_keep'] = 100
default['scrapyd']['poll_interval'] = 5.0
default['scrapyd']['runner'] = 'scrapyd.runner'
default['scrapyd']['application'] = 'scrapyd.app.application'
default['scrapyd']['webroot'] = 'scrapyd.website.Root'
