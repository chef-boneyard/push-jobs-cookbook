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

# For now, this is guaranteed to exist. Change this when
# chef-ingredient supports installation on windows and we don't
# force users to specify package_url.
version = PushJobsHelper.parse_version(node, node['push_jobs']['package_url'])
service_name = PushJobsHelper.windows_service_name(node, version)

config_file_option = "-c #{PushJobsHelper.config_path}"

# The Parameters key isn't respected by some versions. Inject the
# config file path into ImagePath.
#
# The ImagePath looks like "X:\Path\To\ruby.exe X:\Path\To\windows_service.rb"
# The MSI does not pass any other arguments. So we match the above
# path, just to be extra careful, and then append the "-c path\to\config"
# to it. We need to restart the windows service after performing this
# to ensure that the change takes effect.
#
# If this registry key doesn't exist, then the service has not been
# registered yet and an appropriate error will be thrown when
# a service restart is attempted.
key_path = "HKLM\\SYSTEM\\CurrentControlSet\\Services\\#{service_name}"

registry_key key_path do
  values lazy do
    values = registry_get_values(key_path)
    imagepath = values.find { |x| x[:name] == 'ImagePath' }
    match = imagepath[:data].match(/^(.*ruby\.exe)\s+(\S*windows_service\.rb)/)
    imagepath[:data] = "#{match[1]} #{match[2]} #{config_file_option}"
    [imagepath]
  end
  notifies :restart, "service[#{service_name}]"
  only_if { registry_key_exists?(key_path) }
end

service service_name do
  action [:enable, :start]
  subscribes :restart, "template[#{PushJobsHelper.config_path}]"
end
