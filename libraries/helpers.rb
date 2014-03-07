#
# Cookbook Name:: push-jobs
# Library:: helpers
#
# Author:: Joshua Timberman <joshua@getchef.com>
# Author:: Charles Johnson <charles@getchef.com>
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

require 'uri'
require 'chef/config'

# Helper functions for Push Jobs cookbook
module PushJobsHelper
  def self.package_file(url = 'http://www.opscode.com/chef/install.sh')
    uri = ::URI.parse(::URI.unescape(url))
    package_file = File.basename(uri.path)
    package_file
  end

  def self.config_path
    ::File.join(config_dir, 'push-jobs-client.rb')
  end

  def self.config_dir
    Chef::Config.platform_specific_path('/etc/chef')
  end
end
