#
# Cookbook Name:: push-jobs
# Recipe:: windows
#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Charles Johnson <charles@opscode.com>
# Copyright (c) 2013, Opscode, Inc. <legal@opscode.com>
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

# Do not continue if trying to run the Windows recipe on non-Windows
raise 'This recipe only supports Windows' unless node['platform_family'] == 'windows'

if node['push_jobs']['package_url']
  package_url = node['push_jobs']['package_url']
  package_checksum = node['push_jobs']['package_checksum']
else
  package_file = 'opscode-push-jobs-client-1.0.0+20131028192012-1.windows.msi'
  package_url = "https://opscode-push-jobs-client.s3.amazonaws.com/1.0.0-1/#{package_file}"
  package_checksum = PushJobsHelper::DEFAULT_CHECKSUMS[package_file]
end

# OC-7332: need the version as part of the DisplayName. Hardcoding is
# fine for now, it will be removed from the installer when the ticket
# is resolved.
display_name = 'Opscode Push Jobs Client Installer for Windows v0.0.1'

windows_package display_name do
  source package_url
  checksum package_checksum
end

directory Chef::Config.platform_specific_path('/etc/chef')

template Chef::Config.platform_specific_path('/etc/chef/push-jobs-client.rb') do
  source 'push-jobs-client.rb.erb'
  variables(:whitelist => node['push_jobs']['whitelist'])
  notifies :restart, node['push_jobs']['service_string']
end

registry_key 'HKLM\\SYSTEM\\CurrentControlSet\\Services\\pushy-client' do
  values([{
        :name => 'Parameters',
        :type => :string,
        :data => '-c c:\\chef\\push-jobs-client.rb'
      }])
  notifies :restart, node['push_jobs']['service_string']
end

service 'pushy-client' do
  action [:enable, :start]
end
