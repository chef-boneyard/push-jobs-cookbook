#
# Cookbook Name:: push-jobs
# Recipe:: service_windows
#
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

version = PushJobsHelper.parse_version(node, node['push_jobs']['package_url'])
service_name = PushJobsHelper.windows_service_name(node, version)

config_file_option = "-c #{PushJobsHelper.config_path}"

values_to_set = [{ name: 'Parameters',
                   type: :string,
                   data: config_file_option }]

# The Parameters key isn't respected by some versions. Inject the
# config file path into ImagePath.
#
# This is a bit painful, since ImagePath contains a version specific
# path to the windows_service.rb code; we can't know what it is until
# the msi is installed. (The path incorporates the push-client ruby
# gem version, which isn't always correlated with the version of the
# omnibus package. So we can't create this entry before installation,
# yet installation may fail if this isn't set.
#
# The approach below parses the ImagePath from the installer, and adds
# a command line option to point to the config file.
#
key_path = "HKLM\\SYSTEM\\CurrentControlSet\\Services\\#{service_name}"
if registry_key_exists?(key_path)
  values = registry_get_values(key_path)
  imagepath = values.find { |x| x[:name] == 'ImagePath' }
  match = imagepath[:data].match(/^(.*ruby\.exe)\s+(\S*windows_service\.rb)/)
  imagepath[:data] = "#{match[1]} #{match[2]} #{config_file_option}"
  values_to_set << imagepath
end

registry_key "HKLM\\SYSTEM\\CurrentControlSet\\Services\\#{service_name}" do
  values(values_to_set)
  notifies :restart, "service[#{service_name}]"
end

service service_name do
  action [:enable, :start]
  subscribes :restart, "template[#{PushJobsHelper.config_path}]"
end
