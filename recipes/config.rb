#
# Cookbook Name:: push-jobs
# Recipe:: config
#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright (c) 2013, Opscode, Inc. <legal@opscode.com>
# Copyright (c) 2014, Chef Software, Inc. <legal@chef.io>
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
# This recipe is used for both Linux and Windows to separate the config
# from the installation and service
#
# See libraries/helpers for the PushJobsHelper module.
directory PushJobsHelper.config_dir do
  unless platform_family?('windows')
    owner 'root'
    group 'root'
    mode 00755
    recursive true
  end
end

chef_server_url = node['push_jobs']['chef']['chef_server_url'] || Chef::Config.chef_server_url
node_name = node['push_jobs']['chef']['node_name'] || Chef::Config[:node_name]

template PushJobsHelper.config_path do
  source 'push-jobs-client.rb.erb'
  cookbook node['push_jobs']['config']['template_cookbook']
  unless platform_family?('windows')
    owner 'root'
    group 'root'
    mode 00644
  end
  variables(
    chef_server_url: chef_server_url,
    node_name: node_name,
    client_key_path: node['push_jobs']['chef']['client_key_path'],
    trusted_certs_path: node['push_jobs']['chef']['trusted_certs_path'],
    whitelist: node['push_jobs']['whitelist'],
    env_variables: node['push_jobs']['environment_variables'],
    verify_api_cert: node['push_jobs']['chef']['verify_api_cert'],
    ssl_verify_mode: node['push_jobs']['chef']['ssl_verify_mode'],
    include_timestamp: node['push_jobs']['chef']['include_timestamp'])
end
