#
# Cookbook Name:: opscode-push-jobs
# Library:: helpers
#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright (c) 2013, Opscode, Inc. <legal@opscode.com>
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

require 'uri'

module Opscode
  class Pushjobs

    def self.package_file(url="http://www.opscode.com/chef/install.sh")
      package_file = nil
      uri = ::URI.parse(url)
      # This bit of awkwardness is to make sure the file gets downloaded
      # from the folder in the bucket properly.
      uri.path.gsub!(/%2F/, '/')
      package_file = uri.path.split('/')[2]
      package_file
    end

  end
end
