#
# Cookbook Name:: push-jobs
# resource:: service_upstart
#
# Copyright 2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

provides :push_jobs_service_upstart

provides :push_jobs_service, platform: 'ubuntu' do |node|
  node['platform_version'].to_f < 15.10
end

action :start do
  create_init

  service 'chef-push-jobs' do
    supports restart: true, status: true
    action :start
    subscribes :restart, "template[#{PushJobsHelper.config_path}]"
  end
end

action :stop do
  service 'chef-push-jobs' do
    supports status: true
    action :stop
    only_if { ::File.exist?("/etc/init/chef-push-jobs.conf") }
  end
end

action :restart do
  service 'chef-push-jobs' do
    supports restart: true, status: true
    action :restart
  end
end

action :enable do
  create_init

  service 'chef-push-jobs' do
    supports status: true
    action :enable
    only_if { ::File.exist?("/etc/init/chef-push-jobs.conf") }
    subscribes :restart, "template[#{PushJobsHelper.config_path}]"
  end
end

action :disable do
  service 'chef-push-jobs' do
    supports status: true
    action :disable
    only_if { ::File.exist?("/etc/init/chef-push-jobs.conf") }
  end
end

action_class.class_eval do
  def create_init
    include_recipe 'push-jobs::package'

    # service resource for notification
    service 'chef-push-jobs' do
      action :nothing
    end

    template "/etc/init/chef-push-jobs.conf" do
      source 'init_upstart.erb'
      cookbook 'push-jobs'
      variables ({
        :cli_command => PushJobsHelper.cli_command(node)
      })
      notifies :restart, "service[chef-push-jobs]", :immediately
    end
  end
end
