require 'spec_helper'

describe 'push-jobs::default recipe' do
  it 'Installs the push jobs client package' do
    expect(file '/opt/push-jobs-client/bin/pushy-client').to exist
    expect(file '/opt/push-jobs-client/bin/pushy-service-manager').to exist
  end

  it 'Creates the push-jobs-client.rb' do
    expect(file '/etc/chef/push-jobs-client.rb').to be_file
    expect(file '/etc/chef/push-jobs-client.rb').to be_owned_by('root')
    expect(file '/etc/chef/push-jobs-client.rb').to be_grouped_into('root')
    expect(file '/etc/chef/push-jobs-client.rb').to contain('whitelist({"chef-client"=>"chef-client"})')
    expect(file '/etc/chef/push-jobs-client.rb').to contain("LC_ALL='en_US.UTF-8'")
  end
end
