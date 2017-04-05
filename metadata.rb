name 'push-jobs'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs the Chef Push Jobs Client'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '4.0.2'

# Tested on Ubuntu 14.04 - 16.04
# Tested on CentOS 6-7
# Tested on Debian 7-8
supports 'ubuntu'
supports 'centos'
supports 'debian'
supports 'windows'

# For per-platform resources, respectively
depends 'runit', '>= 1.2.0'
depends 'chef-ingredient', '>= 0.19.0'

source_url 'https://github.com/chef-cookbooks/push-jobs'
issues_url 'https://github.com/chef-cookbooks/push-jobs/issues'
chef_version '>= 12.5' if respond_to?(:chef_version)
