#
# Cookbook Name:: push-jobs
# Recipe:: service
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

case node['platform_family']
when 'windows'
  registry_key 'HKLM\\SYSTEM\\CurrentControlSet\\Services\\pushy-client' do
    values([{
          :name => 'Parameters',
          :type => :string,
          :data => "-c #{PushJobsHelper.config_path}"
          }])
    notifies :restart, node['push_jobs']['service_string']
  end

  service 'pushy-client' do
    action [:enable, :start]
    subscribes :restart, "template[#{PushJobsHelper.config_path}]"
  end
when 'debian', 'rhel'
  include_recipe 'runit'

  runit_service 'opscode-push-jobs-client' do
    default_logger true
    subscribes :restart, "template[#{PushJobsHelper.config_path}]"
  end
end
