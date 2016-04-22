name 'push-jobs'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs the Chef Push Jobs Client'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.6.4'

# Tested on Ubuntu 14.04, 12.04, 10.04
# Tested on CentOS 7.1, 6.6, 5.11
supports 'ubuntu'
supports 'centos'
supports 'debian'
supports 'windows'

# For per-platform resources, respectively
depends 'runit'
depends 'windows'
depends 'chef-ingredient', '>= 0.18.0'

source_url 'https://github.com/chef-cookbooks/push-jobs' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/push-jobs/issues' if respond_to?(:issues_url)
