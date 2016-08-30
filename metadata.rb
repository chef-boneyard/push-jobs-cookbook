name 'push-jobs'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs the Chef Push Jobs Client'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.2.0'

# Tested on Ubuntu 14.04, 12.04
# Tested on CentOS 7.2, 6.7
supports 'ubuntu'
supports 'centos'
supports 'debian'
supports 'windows'

# For per-platform resources, respectively
depends 'runit', '>= 1.2.0'
depends 'windows', '>= 1.42.0'
depends 'chef-ingredient', '>= 0.18.0'
depends 'compat_resource'

source_url 'https://github.com/chef-cookbooks/push-jobs'
issues_url 'https://github.com/chef-cookbooks/push-jobs/issues'

chef_version '>= 12.0' if respond_to?(:chef_version)
