#
# Cookbook Name:: push-jobs
# Library:: helpers
#
# Author:: Joshua Timberman <joshua@chef.io>
# Author:: Charles Johnson <charles@chef.io>
# Author:: Mark Anderson <mark@chef.io>
# Copyright 2013-2015 Chef Software, Inc. <legal@chef.io>
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

  def self.names_by_version(version)
    if version =~ /^1\.[0-2]/
      { windows: {
          package_name: "Opscode Push Jobs Client Installer for Windows v#{version}",
          service_name: "pushy-client" }
      }
    elsif version =~ /^1\.3/
      { windows: {
           package_name: "Push Jobs Client v#{version}",
           service_name: "push-jobs-client" }
      }
    elsif version =~ /^2\.0\.0-alpha/
       { windows: {
           package_name: "Push Jobs Client v#{version}",
           service_name: "push-jobs-client" }
      }
    else
      raise "No info for version #{version}"
    end
  end

  def self.windows_package_name(node, version)
    if node['push_jobs']['package_name']
      node['push_jobs']['package_name']
    else
      self.names_by_version(version)[:windows][:package_name]
    end
  end

  def self.windows_service_name(node, version)
    if node['push_jobs']['service_name']
      node['push_jobs']['service_name']
    else
      self.names_by_version(version)[:windows][:service_name]
    end
  end

  def self.parse_version(node, url)
    return node['push_jobs']['version'] if node['push_jobs']['version']
    if url =~ /\-(\d+\.\d+\.\d+)\-/
      return Regexp.last_match(1)
    else
      return ''
    end
  end
end

#
# Reference values
#
# 1.1.x opscode-push-jobs-client-windows-1.1.4-1.windows.msi
# PName: "Opscode Push Jobs Client Installer for Windows v1.1.4"
# Install Path: /opt/opscode/pushy (C:/opscode/pushy)
# Registry (pushy-client)
## DisplayName: Pushy Client Service
## ImagePath: C:\opscode\pushy\embedded\bin\ruby.exe C:\opscode\pushy\embedded\lib\ruby\gems\1.9.1\gems\opscode-pushy-client-1.1.3\lib\pushy_client\windows_service.rb

#
# 1.3.x push-jobs-client-1.3.3-1.msi
# PName: "Push Jobs Client v1.3.3"
# Install Path: /opt/opscode/push-jobs-client (C:/opscode/push-jobs-client)
# Registry (push-jobs-client)
## DisplayName: Push Jobs Client Service
## ImagePath: C:\opscode\push-jobs-client\embedded\bin\ruby.exe C:\opscode\push-jobs-client\embedded\lib\ruby\gems\2.1.0\gems\opscode-pushy-client-1.3.3\lib\pushy_client\windows_service.rb
