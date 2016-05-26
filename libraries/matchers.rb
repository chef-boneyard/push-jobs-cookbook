#
# Cookbook Name:: memcached
# Library:: matchers
#
# Author:: Tim Smith (<tsmith@chef.io>)
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

if defined?(ChefSpec)
  ChefSpec.define_matcher :push_jobs_service

  def start_push_jobs_service_upstart(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:push_jobs_service, :start, resource_name)
  end

  def enable_push_jobs_service_upstart(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:push_jobs_service, :enable, resource_name)
  end

  def restart_push_jobs_service_upstart(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:push_jobs_service, :restart, resource_name)
  end

  def stop_push_jobs_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:push_jobs_service, :stop, resource_name)
  end

  def disable_push_jobs_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:push_jobs_service, :disable, resource_name)
  end

  def start_push_jobs_service_upstart_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:push_jobs_service_runit, :start, resource_name)
  end

  def enable_push_jobs_service_upstart_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:push_jobs_service_runit, :enable, resource_name)
  end

  def restart_push_jobs_service_upstart_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:push_jobs_service_runit, :restart, resource_name)
  end

  def stop_push_jobs_service_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:push_jobs_service_runit, :stop, resource_name)
  end

  def disable_push_jobs_service_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:push_jobs_service_runit, :disable, resource_name)
  end

  def create_push_jobs_service_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:push_jobs_service_runit, :create, resource_name)
  end

  def remove_push_jobs_service_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:push_jobs_service_runit, :remove, resource_name)
  end
end
