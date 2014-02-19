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

package_url      = node['push_jobs']['package_url']
package_file     = PushJobsHelper.package_file(node['push_jobs']['package_url'])
package_checksum = node['push_jobs']['package_checksum']

remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
  source package_url
  checksum package_checksum
  mode 00644
end

package 'opscode-push-jobs-client' do
  case node['platform_family']
  when 'debian'
    provider Chef::Provider::Package::Dpkg
  when 'rhel'
    provider Chef::Provider::Package::Rpm
  end
  source "#{Chef::Config[:file_cache_path]}/#{package_file}"
end

unless File.exists?(Chef::Config.platform_specific_path('/etc/chef'))
  directory Chef::Config.platform_specific_path('/etc/chef') do
    owner 'root'
    group 'root'
    mode 00755
  end
end

template Chef::Config.platform_specific_path('/etc/chef/push-jobs-client.rb') do
  source 'push-jobs-client.rb.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables(:whitelist => node['push_jobs']['whitelist'])
  notifies :restart, node['push_jobs']['service_string']
end

include_recipe 'runit'

runit_service 'opscode-push-jobs-client' do
  default_logger true
end
