name 'scrapyd-deploy'
maintainer 'Neal Wong'
maintainer_email 'neal.wkacc@gmail.com'
license 'All Rights Reserved'
description 'Installs/Configures scrapyd-deploy'
long_description 'Installs/Configures scrapyd-deploy'
version '0.1.7'
chef_version '>= 12.1' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/scrapyd-deploy/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/scrapyd-deploy'

depends 'pyenv', '~> 3.0.0'
