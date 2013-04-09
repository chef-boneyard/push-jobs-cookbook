#
# Cookbook Name:: opscode-push-jobs
# Recipe:: windows
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

# OC-7332: need the version as part of the DisplayName. Hardcoding is
# fine for now, it will be removed from the installer when the ticket
# is resolved.
display_name = "Opscode Push Jobs Client Installer for Windows v0.0.1"

windows_package display_name do
  source node['opscode_push_jobs']['package_url']
  checksum node['opscode_push_jobs']['package_checksum']
end

include_recipe "opscode-push-jobs::config"

registry_key "HKLM\\SYSTEM\\CurrentControlSet\\Services\\pushy-client" do
  values([{
        :name => "Parameters",
        :type => :string,
        :data => "-c c:\chef\push-jobs-client.rb"
      }])
end

service "pushy-client" do
  action [:enable, :start]
end
