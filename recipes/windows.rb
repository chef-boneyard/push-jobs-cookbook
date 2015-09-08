#
# Cookbook Name:: push-jobs
# Recipe:: windows
#
# Author:: Joshua Timberman <joshua@getchef.com>
# Author:: Charles Johnson <charles@getchef.com>
# Author:: Christopher Maier <cm@getchef.com>
# Copyright 2013-2014 Chef Software, Inc. <legal@getchef.com>
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
raise 'This recipe only supports Windows' unless node['platform_family'] == 'windows'

# Ensure the config is available before installing and starting the service
include_recipe 'push-jobs::config'

windows_package "Opscode Push Jobs Client Installer for Windows v#{PushJobsHelper.parse_version(node['push_jobs']['package_url'])}" do
  source node['push_jobs']['package_url']
  checksum node['push_jobs']['package_checksum']
end

include_recipe 'push-jobs::service'
