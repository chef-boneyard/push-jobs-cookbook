#
# Cookbook:: push-jobs
# Recipe:: linux
#
# Author:: Joshua Timberman <joshua@chef.io>
# Author:: Charles Johnson <charles@chef.io>
# Author:: Christopher Maier <cm@chef.io>
# Copyright:: 2013-2016, Chef Software, Inc. <legal@chef.io>
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node['push_jobs']['package_url']
  raise 'Must specify package_checksum if package_url is specified' unless node['push_jobs']['package_checksum']

  package_version    = PushJobsHelper.parse_version(node, node['push_jobs']['package_url'])
  package_url        = node['push_jobs']['package_url']
  package_file       = PushJobsHelper.package_file(node['push_jobs']['package_url'])
  local_package_path = "#{Chef::Config[:file_cache_path]}/#{package_file}"
  package_checksum   = node['push_jobs']['package_checksum']

  raise 'Unable to parse the package\'s version from either the [\'push_jobs\'][\'package_version\'] or [\'push_jobs\'][\'package_url\'] attributes. Please ensure that the [\'push_jobs\'][\'package_version\'] attribute is set. Alternatively, you could update the [\'push_jobs\'][\'package_url\' attribute to include a version number' if package_version.nil?

  remote_file local_package_path do
    source package_url
    checksum package_checksum
    mode '644'
  end

elsif node['push_jobs']['local_package_path']
  package_version    = PushJobsHelper.parse_version(node, node['push_jobs']['local_package_path'])
  local_package_path = node['push_jobs']['local_package_path']

else
  Chef::Log.info("Neither ['push_jobs']['local_package_path'] nor ['push_jobs']['package_url'] and ['push_jobs']['package_checksum'] set. Chef Push Jobs client will be installed from downloads.chef.io.")
  package_version = node['push_jobs']['package_version']
end

#
# This uses packages.chef.io by default.
#
chef_ingredient 'push-jobs-client' do
  version package_version if package_version
  package_source local_package_path if local_package_path
  platform_version_compatibility_mode true
end
