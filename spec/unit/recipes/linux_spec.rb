require 'spec_helper'

describe 'push-jobs::linux' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'ubuntu', version: '10.04')
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

  it 'includes the config recipe' do
    expect(chef_run).to include_recipe("#{described_cookbook}::config")
  end

  it 'starts the opscode-push-jobs-client' do
    pending 'Write a custom matcher for the runit_service definition'
    expect(chef_run).to start_service 'opscode-push-jobs-client'
  end

end
