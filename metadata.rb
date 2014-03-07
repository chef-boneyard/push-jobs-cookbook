name             'push-jobs'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@getchef.com'
license          'Apache 2.0'
description      'Installs the Chef Push Jobs Client'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.2.0'

# Tested on Ubuntu 10.04, 12.04
# Tested on CentOS 6.4, 5.9
supports 'ubuntu'
supports 'centos'
supports 'debian'
supports 'windows'

# For per-platform resources, respectively
depends 'runit'
depends 'windows'

attribute('push_jobs/package_url',
          :description => 'URL to a client package to download
          for installing Chef Push Job Client')

attribute('push_jobs/package_checksum',
          :description => 'Checksum of the package file from package_url,
          use this to prevent download every Chef run')

attribute('push_jobs/gem_url',
          :description => 'URL to the knife plugin gem file')

attribute('push_jobs/gem_checksum',
          :description => 'Checksum of the gem file from gem_url,
          use this to prevent download every Chef run')

attribute('push_jobs/whitelist',
          :description => 'Hash of whitelist jobs for the push client configuration')

attribute('push_jobs/service_string',
          :description => 'String of the resource for the service, varies by platform.')
