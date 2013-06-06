#
# Cookbook Name:: push-jobs
# Recipe:: config
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

directory Chef::Config.platform_specific_path("/etc/chef") do
  unless platform_family?("windows")
    owner "root"
    group "root"
    mode 00755
  end
end

template Chef::Config.platform_specific_path("/etc/chef/push-jobs-client.rb") do
  source "push-jobs-client.rb.erb"
  unless platform_family?("windows")
    owner "root"
    group "root"
    mode 00644
  end
  variables(:whitelist => node['push_jobs']['whitelist'])
  notifies :restart, node['push_jobs']['service_string']
end
