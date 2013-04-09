#
# Cookbook Name:: opscode-push-jobs
# Recipe:: debian
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

package_file = Opscode::Pushjobs.package_file(node['opscode_push_jobs']['package_url'])

remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
  source node['opscode_push_jobs']['package_url']
  checksum node['opscode_push_jobs']['package_checksum']
  mode 00644
end

package "opscode-push-jobs-client" do
  if node['opscode_push_jobs']['package_url']
    provider Chef::Provider::Package::Dpkg
    source "#{Chef::Config[:file_cache_path]}/#{package_file}"
  end
end

include_recipe "opscode-push-jobs::config"
include_recipe "runit"

runit_service "opscode-push-jobs-client" do
  default_logger true
end
