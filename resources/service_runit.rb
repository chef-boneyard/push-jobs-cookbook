#
# Cookbook Name:: push-jobs
# resource:: service_runit
#
# Author Tim Smith <tsmith@chef.io>
# Copyright 2009-2016, Chef Software, Inc.
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

provides :push_jobs_service

provides :push_jobs_service_runit

action :start do
  create_init

  runit_service 'chef-push-jobs-client' do
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  runit_service 'chef-push-jobs-client' do
    supports status: true
    action :stop
    only_if { ::File.exist?('/etc/sv/chef-push-jobs-client/run') }
  end
end

action :restart do
  runit_service 'chef-push-jobs-client' do
    supports restart: true, status: true
    action :restart
  end
end

action :enable do
  create_init

  runit_service 'chef-push-jobs-client' do
    supports status: true
    action :enable
  end
end

action :disable do
  runit_service 'chef-push-jobs-client' do
    supports status: true
    action :disable
    only_if { ::File.exist?('/etc/sv/chef-push-jobs-client/run') }
  end
end

action_class.class_eval do
  def create_init
    include_recipe 'runit'
    include_recipe 'push-jobs::package'

    # disable the old service
    runit_service 'opscode-push-jobs-client' do
      action [:stop, :disable]
    end

    # remove old init script link
    file '/etc/init.d/opscode-push-jobs-client' do
      action :delete
    end

    # remove the old service configs
    directory '/etc/sv/opscode-push-jobs-client' do
      recursive true
      action :delete
    end

    runit_service 'chef-push-jobs-client' do
      options('cli_command' => PushJobsHelper.cli_command(node))
      default_logger true
      subscribes :restart, "template[#{PushJobsHelper.config_path}]"
    end
  end
end
