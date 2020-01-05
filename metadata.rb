name 'push-jobs'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs the Chef Push Jobs Client'
version '5.3.0'

supports 'ubuntu'
supports 'centos'
supports 'debian'
supports 'amazon'
supports 'windows'

depends 'runit', '>= 1.2.0'
depends 'chef-ingredient'

source_url 'https://github.com/chef-cookbooks/push-jobs'
issues_url 'https://github.com/chef-cookbooks/push-jobs/issues'
chef_version '>= 12.15'
