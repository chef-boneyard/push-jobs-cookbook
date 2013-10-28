#
# Author:: Joshua Timberman <jtimberman@champagne.int.housepub.org>
# Author:: Charles Johnson <charles@opscode.com>
# Copyright:: Copyright (c) 2013, Joshua Timberman
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['push_jobs']['package_url'] = nil
default['push_jobs']['package_checksum'] = ''
default['push_jobs']['package_version'] = '1.0.0-1'
default['push_jobs']['gem_url'] = nil
default['push_jobs']['gem_checksum'] = ''

default['push_jobs']['whitelist']   = { 'chef-client' => 'chef-client' }

case node['platform_family']
when 'debian', 'rhel'
  default['push_jobs']['service_string'] = 'runit_service[opscode-push-jobs-client]'
when 'windows'
  default['push_jobs']['service_string'] = 'service[pushy-client]'
end

# These are the sha256 checksums of each platform's package, for when they are determined and retrieved algorithmically
default['push_jobs']['default_package_checksums'] = {
  'opscode-push-jobs-client-1.0.0+20131028192012-1.windows.msi' => 'ab3deb425682b1f025fce1980b91ed88d0912051c0801c7a295a17c2ac75096a',
  'opscode-push-jobs-client-1.0.0-1.el5.i686.rpm' => '0e6023b7d1b853eed63133f7d1e63fd6d55f5a06793098f016063669162bfae8',
  'opscode-push-jobs-client-1.0.0-1.el5.x86_64.rpm' => 'fadfa187e67f79f5d079843c7758a369dd9237be2db83fad46b24d607f827056',
  'opscode-push-jobs-client-1.0.0-1.el6.i686.rpm' => 'acda0d7389b81ead4e83883177a6c28fdafdd1f889229cc5c4c90646213a8c88',
  'opscode-push-jobs-client-1.0.0-1.el6.x86_64.rpm' => 'aaf73394de3bcea955fd791aa50d0ee27aaea8a0ac54fb839d31313912814343',
  'opscode-push-jobs-client_1.0.0-1.debian.6.0.5_amd64.deb' => '36181b0cd881a106d80c9b51d8cc694051b6983e3ddc292ef91888e745f81006',
  'opscode-push-jobs-client_1.0.0-1.debian.6.0.5_i386.deb' => 'f4e0e403bc0fb0c907ce7f72eb52cb6b58108cf906d63648dfc1ad7558397270',
  'opscode-push-jobs-client_1.0.0-1.ubuntu.10.04_amd64.deb' => '1dbfaf2f2e7c427c3dc53cc66df03c38dc4a91f4dc07145ec300da35de0cbf86',
  'opscode-push-jobs-client_1.0.0-1.ubuntu.10.04_i386.deb' => '6a72eb218c66bf4155ed71ce358724d905c351c8e8894a2eb6806387ac7a9066',
  'opscode-push-jobs-client_1.0.0-1.ubuntu.11.04_amd64.deb' => '8aa01ffbeba089cc321fc0a0aab2e8064f69120165e638e79d3b1cd713904f1a',
  'opscode-push-jobs-client_1.0.0-1.ubuntu.11.04_i386.deb' => 'db91e682c782e32042d43d9ec39eec0d47f9348ea998177d3b2ae29402640035',
  'opscode-push-jobs-client_1.0.0-1.ubuntu.12.04_amd64.deb' => 'b32e439f1fd6f38dc7acfeb2d31fb173e9d5b3cbb439f88cee0ed19b2229e97b'
}
