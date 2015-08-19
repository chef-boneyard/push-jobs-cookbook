require 'spec_helper'

describe 'push-jobs::windows' do

  cached(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2')
    runner.node.set['push_jobs']['package_url'] = 'http://foo.bar.com/opscode-push-jobs-client-windows-1.1.5-1.windows.msi?key=value'
    runner.node.set['push_jobs']['whitelist'] = { 'chef-client' => 'chef-client' }
    runner.converge('recipe[push-jobs::windows]')
  end

  it 'Installs the MSI file' do
    display_name = 'Opscode Push Jobs Client Installer for Windows v1.1.5'
    expect(chef_run).to install_windows_package "#{display_name}"
  end

  it 'Includes the config recipe' do
    expect(chef_run).to include_recipe "#{described_cookbook}::config"
  end

  it 'Configures the pushy-client registry key' do
    expect(chef_run).to create_registry_key('HKLM\\SYSTEM\\CurrentControlSet\\Services\\pushy-client')
  end

  it 'Starts & enables the pushy-client service' do
    expect(chef_run).to enable_service 'pushy-client'
    expect(chef_run).to start_service 'pushy-client'
  end

end
