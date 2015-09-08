require 'spec_helper'

describe 'push-jobs::linux' do
  cached(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '10.04')
    runner.converge('recipe[push-jobs::config]')
  end

  it 'Creates the /etc/chef directory' do
    expect(chef_run).to create_directory '/etc/chef'
  end

  it 'Creates the /etc/chef/push-jobs-client.rb file' do
    expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('whitelist({"chef-client"=>"chef-client"})')
  end
end
