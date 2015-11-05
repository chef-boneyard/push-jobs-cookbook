#
# Cookbook Name:: push-jobs
# Recipe:: windows
#
# Author:: Joshua Timberman <joshua@chef.io>
# Author:: Charles Johnson <charles@chef.io>
# Author:: Christopher Maier <cm@chef.io>
# Author:: Mark Anderson <mark@chef.io>
# Copyright 2013-2015 Chef Software, Inc. <legal@chef.io>
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

# Do not continue if trying to run the Windows recipe on non-Windows
fail 'This recipe only supports Windows' unless node['platform_family'] == 'windows'

version = PushJobsHelper.parse_version(node, node['push_jobs']['package_url'])
package_name = PushJobsHelper.windows_package_name(node, version)
windows_package package_name do
  source node['push_jobs']['package_url']
  checksum node['push_jobs']['package_checksum']
end

include_recipe 'push-jobs::config'
include_recipe 'push-jobs::service'
