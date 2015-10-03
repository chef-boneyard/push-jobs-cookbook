#
# Cookbook Name:: push-jobs
# Recipe:: service_runit
#
# Author:: Mark Anderson <mark@chef.io>
# Copyright 2015 Chef Software, Inc. <legal@chef.io>
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

require 'chef-init'
require 'chef/provider/container_service'
require 'chef/resource/container_service'

service 'opscode-push-jobs-client' do
  provider Chef::Provider::ContainerService::Runit
  options(logging_level: node['push_jobs']['logging_level'],
          config: PushJobsHelper.config_path)
  action :start
  subscribes :restart, "template[#{PushJobsHelper.config_path}]"
end
