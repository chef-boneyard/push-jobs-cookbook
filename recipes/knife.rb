#
# Cookbook Name:: push-jobs
# Recipe:: knife
#
# Author:: Joshua Timberman <joshua@getchef.com>
# Author:: Charles Johnson <charles@getchef.com>
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

# Do not continue without a download URL
raise 'Please define the [\'push_jobs\'][\'gem_url\'] attribute before continuing.' unless node['push_jobs']['gem_url']

package_file = PushJobsHelper.package_file(node['push_jobs']['gem_url'])

remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
  source node['push_jobs']['gem_url']
  checksum node['push_jobs']['gem_checksum']
  mode 00644
end

gem_package package_file do
  source "#{Chef::Config[:file_cache_path]}/#{package_file}"
end
