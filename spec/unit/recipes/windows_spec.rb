require 'spec_helper'

describe 'push-jobs::windows' do

  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'windows', version: '2008R2')
    runner.node.set['push_jobs']['package_url'] = 'http://foo.bar.com/opscode-push-jobs-client_x86_64.msi?key=value'
    runner.node.set['push_jobs']['whitelist'] = { 'chef-client' => 'chef-client' }
    runner.converge('recipe[push-jobs::windows]')
  end

  it 'Installs the MSI file' do
    pending 'Extend the package matcher for Windows_package'
    display_name = 'Opscode Push Jobs Client Installer for Windows'
    expect(chef_run).to install_windows_package "#{display_name}"
  end

  it 'Creates the /etc/chef directory' do
    expect(chef_run).to create_directory '/etc/chef'
  end

  it 'Creates the /etc/chef/push-jobs-client.rb file' do
    expect(chef_run).to create_file_with_content '/etc/chef/push-jobs-client.rb', 'whitelist({"chef-client"=>"chef-client"})'
  end

  it 'Configures the pushy-client registry key' do
    pending 'Write a custom matcher for registry_key'
    expect(chef_run).to create_registry_key('HKLM\\SYSTEM\\CurrentControlSet\\Services\\pushy-client')
  end

  it 'Starts & enables the pushy-client service' do
    expect(chef_run).to enable_service 'pushy-client'
    expect(chef_run).to start_service 'pushy-client'
  end

end
