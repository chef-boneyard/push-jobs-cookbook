#
# Cookbook Name:: opscode-push-jobs
# Recipe:: default
#
# Author:: Joshua Timberman <joshua@opscode.com>
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

package_file = nil

if node['opscode_push_jobs']['package_url']
  require 'uri'
  uri = URI.parse(node['opscode_push_jobs']['package_url'])
  package_file = uri.path.split('/')[2]

  remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
    source node['opscode_push_jobs']['package_url']
    mode 00644
  end

end

package "opscode-push-jobs-client" do
  if node['opscode_push_jobs']['package_url']
    provider Chef::Provider::Package::Dpkg
    source "#{Chef::Config[:file_cache_path]}/#{package_file}"
  end
end

directory "/etc/chef" do
  owner "root"
  group "root"
  mode 00755
end

template "/etc/chef/push-jobs-client.rb" do
  source "push-jobs-client.rb.erb"
  owner "root"
  group "root"
  mode 00644
  variables(:whitelist => node['opscode_push_jobs']['whitelist'])
  notifies :restart, "runit_service[opscode-push-jobs-client]"
end

include_recipe "runit"

runit_service "opscode-push-jobs-client" do
  default_logger true
end
