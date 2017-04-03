#
# Cookbook:: push-jobs
# Recipe:: service_windows
#
# Author:: Tyler Fitch <tfitch@chef.io>
# Copyright:: 2013-2016, Chef Software, Inc. <legal@chef.io>
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
key_path = "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\#{service_name}"

# The Parameters key isn't respected by some versions. Inject the
# config file path into ImagePath.
#
# The ImagePath looks like "X:\Path\To\ruby.exe X:\Path\To\windows_service.rb"
# The MSI does not pass any other arguments. So we match the above
# path, just to be extra careful, and then append the "-c path\to\config"
# to it. We need to restart the windows service after performing this
# to ensure that the change takes effect. We make an assumption that there
# are no spaces anywhere in any of the paths (because we don't want to
# write a full on command parser that handles quotes and stuff).
#
# We could use a registry resource from Chef here but the value we
# wish to compute for ImagePath is resolved at run-time. As of Chef 12.5.1
# the core registry resource does not support a lazy value for its
# values attribute. This is a workaround.
powershell_script 'Set the config path in the service registry key' do
  code <<-EOH
    $KeyPath = '#{key_path}'
    $ImagePath = (Get-ItemProperty -Path $KeyPath).ImagePath
    if ($ImagePath -match "^(\\S*ruby.exe\\b)\\s+(\\S*windows_service.rb\\b)") {
      $ImagePath = $matches[1], $matches[2], '#{config_file_option}' -join ' '
      Set-ItemProperty -Path $KeyPath -Name ImagePath -Type String -Value $ImagePath
    } else {
      throw "ImagePath of $KeyPath has unexpected value $ImagePath"
    }
  EOH
  not_if <<-EOH
    $KeyPath = '#{key_path}'
    (Get-ItemProperty -Path $KeyPath).ImagePath.Contains('#{config_file_option}')
  EOH
  notifies :restart, "service[#{service_name}]"
end

service service_name do
  action [:enable, :start]
  subscribes :restart, "template[#{PushJobsHelper.config_path}]"
end
