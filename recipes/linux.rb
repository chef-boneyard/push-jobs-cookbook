#
# Cookbook Name:: push-jobs
# Recipe:: linux
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

# Do not continue if trying to run the Linux recipe on Windows
raise 'This recipe does not support Windows' if node['platform_family'] == 'windows'

if node['push_jobs']['package_url'] && node['push_jobs']['package_checksum']
  package_url      = node['push_jobs']['package_url']
  package_file     = PushJobsHelper.package_file(node['push_jobs']['package_url'])
  package_checksum = node['push_jobs']['package_checksum']
  
  remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
    source package_url
    checksum package_checksum
    mode 00644
  end

else  
  Chef::Log.info("['push_jobs']['package_url'] and ['push_jobs']['package_checksum'] not set. Chef Push client will be installed from CHEF's public repositories.")
end

chef_ingredient 'push-client' do
  version node['push_jobs']['package_version']
  package_source "#{Chef::Config[:file_cache_path]}/#{package_file}" if package_url
end

include_recipe 'push-jobs::config'
include_recipe 'push-jobs::service'
