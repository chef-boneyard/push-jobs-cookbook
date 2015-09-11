#
# Cookbook Name:: push-jobs
# Recipe:: service
#
# Author:: Joshua Timberman <joshua@chef.io>
# Author:: Charles Johnson <charles@chef.io>
# Author:: Christopher Maier <cm@chef.io>
# Author:: Tyler Fitch <tfitch@chef.io>
# Copyright 2013-2014 Chef Software, Inc. <legal@chef.io>
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

supported_init_styles = %w(
  container
  runit
  windows
)

init_style = node['push_jobs']['init_style']

# Services moved to recipes
if supported_init_styles.include? init_style
  include_recipe "push-jobs::service_#{init_style}"
else
  log 'Could not determine service init style, manual intervention required to start up the push-jobs-client service.'
end
