#
# Cookbook Name:: push-jobs
# resource:: service_systemd
#
# Author Tim Smith <tsmith@chef.io>
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

provides :push_jobs_service_systemd

provides :push_jobs_service, platform: %w(redhat centos scientific oracle) do |node| # ~FC005
  node['platform_version'].to_f >= 7.0
end

provides :push_jobs_service, platform: 'debian' do |node|
  node['platform_version'].to_i >= 8
end

provides :push_jobs_service, platform: 'ubuntu' do |node|
  node['platform_version'].to_f >= 15.10
end

action :start do
  delete_runit
  create_init

  service 'chef-push-jobs-client' do
    supports restart: true, status: true
    action :start
    subscribes :restart, "template[#{PushJobsHelper.config_path}]"
  end
end

action :stop do
  service 'chef-push-jobs-client' do
    supports status: true
    action :stop
    only_if { ::File.exist?('/etc/systemd/system/chef-push-jobs-client.service') }
  end
end

action :restart do
  service 'chef-push-jobs-client' do
    supports restart: true, status: true
    action :restart
  end
end

action :disable do
  service 'chef-push-jobs-client' do
    supports status: true
    action :disable
    only_if { ::File.exist?('/etc/systemd/system/chef-push-jobs-client.service') }
  end
end

action :enable do
  create_init

  service 'chef-push-jobs-client' do
    supports status: true
    action :enable
    only_if { ::File.exist?('/etc/systemd/system/chef-push-jobs-client.service') }
    subscribes :restart, "template[#{PushJobsHelper.config_path}]"
  end
end

action_class.class_eval do
  def create_init
    include_recipe 'push-jobs::package'

    # service resource for notification
    service 'chef-push-jobs-client' do
      action :nothing
    end

    template '/etc/systemd/system/chef-push-jobs-client.service' do
      source 'init_systemd.erb'
      cookbook 'push-jobs'
      variables cli_command: PushJobsHelper.cli_command(node)
      notifies :run, 'execute[reload_unit_file]', :immediately
      notifies :restart, 'service[chef-push-jobs-client]', :immediately
    end

    # systemd is cool like this
    execute 'reload_unit_file' do
      command 'systemctl daemon-reload'
      action :nothing
    end
  end

  def delete_runit
    if ::File.exist?('/etc/sv/opscode-push-jobs-client/run')
      # disable the old service
      runit_service 'opscode-push-jobs-client' do
        action [:stop, :disable]
        not_if { ::File.zero?('/etc/sv/opscode-push-jobs-client/supervise/pid') }
      end

      # remove the old service configs
      directory '/etc/sv/opscode-push-jobs-client' do
        recursive true
        action :delete
      end

      # remove old init script link
      file '/etc/init.d/opscode-push-jobs-client' do
        action :delete
      end
    end
  end
end
