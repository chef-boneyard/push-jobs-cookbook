#
# Cookbook:: push-jobs
# resource:: service_systemd
#
# Author:: Thomas Cate <tcate@chef.io>
# Copyright:: 2018, Chef Software, Inc.
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
provides :push_jobs_service_aix

action :start do
  service 'push-jobs-client' do
    action :start
  end
end

action :stop do
  service 'push-jobs-client' do
    action :stop
  end
end

action :restart do
  service 'push-jobs-client-stop' do
    service_name 'push-jobs-client'
    action [:stop]
  end

  ruby_block 'wait for push-jobs to stop' do
    block do

      def check_if_stopped()
        push_status = `/usr/bin/lssrc -s push-jobs-client`.split.last
        if(push_status == "inoperative")
          return true
        else
          return false
        end
      end

      braker = 0
      loop do
        sleep 1
        braker +=1
        break if(check_if_stopped == true)
        if(braker > 15)
          Chef::Log.error("Push Jobs Service failed to stop")
          exit 1
        end
      end 
    end
  end

  service 'push-jobs-client-start' do
    service_name 'push-jobs-client'
    action [:start]
  end
end