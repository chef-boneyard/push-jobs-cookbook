#
# Author:: Joshua Timberman <jtimberman@champagne.int.housepub.org>
# Copyright:: Copyright (c) 2013, Joshua Timberman
# License:: Apache License, Version 2.0
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

default['opscode_push_jobs']['package_url'] = nil
default['opscode_push_jobs']['gem_url']     = nil
default['opscode_push_jobs']['whitelist']   = {}

case node['platform_family']
when 'debian'
  default['opscode_push_jobs']['service_string'] = 'runit_service[opscode-push-jobs-client]'
when 'windows'
  default['opscode_push_jobs']['service_string'] = 'service[pushy-client]'
end
