#
# Cookbook:: push-jobs
# resource:: service_runit
#
# Author:: Tim Smith <tsmith@chef.io>
# Copyright:: 2009-2016, Chef Software, Inc.
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

resource_name :push_jobs_package

property :version
property :channel, Symbol, default: :stable, equal_to: [:stable, :current, :unstable]
property :package_source
property :package_checksum

action :install do
  download_remote_file

  chef_ingredient 'push-jobs-client' do
    version new_resource.version unless new_resource.version.nil?
    package_source local_package_path unless new_resource.package_source.nil?
    platform_version_compatibility_mode true
  end
end

action :upgrade do
  download_remote_file

  chef_ingredient 'push-jobs-client' do
    version new_resource.version unless new_resource.version.nil?
    package_source local_package_path unless new_resource.package_source.nil?
    platform_version_compatibility_mode true
    action :upgrade
  end
end

action_class do
  def download_remote_file
    return unless new_resource.package_source

    # parse the file from the source URL
    package_file = PushJobsHelper.package_file(node['push_jobs']['package_url'])

    remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
      source new_resource.package_source
      checksum new_resource.package_checksum unless new_resourcce.package_checksum.nil?
    end
  end
end
