#
# Cookbook Name:: push-jobs
# Recipe:: linux
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

# Do not continue if trying to run the Linux recipe on Windows
raise 'This recipe does not support Windows' if node['platform_family'] == 'windows'

if node['push_jobs']['package_url']
  package_url = node['push_jobs']['package_url']
  package_file = PushJobsHelper.package_file(node['push_jobs']['package_url'])
  package_checksum = node['push_jobs']['package_checksum']
else
  package_version = node['push_jobs']['package_version']
  # Patterned off of http://opscode.com/chef/install.sh
  # Unknown: /etc/lsb-release
  if platform?('debian')
    # opscode-push-jobs-client_1.0.0-1.debian.6.0.5_amd64.deb
    # opscode-push-jobs-client_1.0.0-1.debian.6.0.5_i386.deb
    package_machine = node['kernel']['machine']
    package_machine = 'amd64' if package_machine == 'x86_64'

    package_file = "opscode-push-jobs-client_#{package_version}.debian.#{node['platform_version']}_#{package_machine}.deb"
  elsif platform?('ubuntu')
    # opscode-push-jobs-client_1.0.0-1.ubuntu.10.04_amd64.deb
    # opscode-push-jobs-client_1.0.0-1.ubuntu.10.04_i386.deb
    # opscode-push-jobs-client_1.0.0-1.ubuntu.11.04_amd64.deb
    # opscode-push-jobs-client_1.0.0-1.ubuntu.11.04_i386.deb
    # opscode-push-jobs-client_1.0.0-1.ubuntu.12.04_amd64.deb
    # opscode-push-jobs-client_1.0.0-1.ubuntu.12.04_i386.deb
    package_machine = node['kernel']['machine']
    package_machine = 'amd64' if package_machine == 'x86_64'
    package_file = "opscode-push-jobs-client_#{package_version}.ubuntu.#{node['platform_version']}_#{package_machine}.deb"
  elsif platform?('centos')
    # opscode-push-jobs-client-1.0.0-1.el5.i686.rpm
    # opscode-push-jobs-client-1.0.0-1.el5.x86_64.rpm
    # opscode-push-jobs-client-1.0.0-1.el6.i686.rpm
    # opscode-push-jobs-client-1.0.0-1.el6.x86_64.rpm
    package_file = "opscode-push-jobs-client-#{package_version}.el#{node['platform_version'].to_i}.#{node['kernel']['machine']}.rpm"
  else
    package_file = nil
  end

  package_url = "https://opscode-push-jobs-client.s3.amazonaws.com/#{package_version}/#{package_file}"
  package_checksum = node['push_jobs']['default_package_checksums'][package_file]
  if !package_checksum
    raise "Unable to determine proper Push Jobs Client package for platform #{node['platform']} version #{node['platform_version']} on #{node['kernel']['machine']}.  Please specify package_url and package_checksum explicitly."
  end
end

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

directory Chef::Config.platform_specific_path('/etc/chef') do
  owner 'root'
  group 'root'
  mode 00755
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
