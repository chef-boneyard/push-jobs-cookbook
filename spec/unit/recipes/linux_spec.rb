require 'spec_helper'

describe 'push-jobs::linux' do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '10.04')
    runner.node.set['push_jobs']['package_url'] = 'http://foo.bar.com/opscode-push-jobs-client_amd64.deb?key=value'
    runner.node.set['push_jobs']['whitelist'] = { 'chef-client' => 'chef-client' }
    runner.converge('recipe[push-jobs::linux]')
  end

  it 'fetches the push jobs package' do
    package_file = 'opscode-push-jobs-client_amd64.deb'
    expect(chef_run).to create_remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}"
  end

  it 'installs the push jobs package' do
    expect(chef_run).to install_package 'opscode-push-jobs-client'
  end

  it 'Creates the /etc/chef directory' do
    expect(chef_run).to create_directory '/etc/chef'
  end

  it 'Creates the /etc/chef/push-jobs-client.rb file' do
    expect(chef_run).to create_file_with_content '/etc/chef/push-jobs-client.rb', 'whitelist({"chef-client"=>"chef-client"})'
    file = chef_run.template('/etc/chef/push-jobs-client.rb')
    expect(file).to be_owned_by('root', 'root')
  end

  it 'starts the opscode-push-jobs-client' do
    pending 'Write a custom matcher for the runit_service definition'
    expect(chef_run).to start_service 'opscode-push-jobs-client'
  end

end
