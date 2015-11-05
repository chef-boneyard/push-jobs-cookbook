require 'spec_helper'

describe 'push-jobs::default recipe' do
  it 'Installs the push jobs client' do
    expect(file 'C:/opscode/pushy/bin/pushy-client.bat').to be_file
  end

  it 'Enables the pushy client service' do
    expect(service 'pushy-client').to be_installed
    expect(service 'pushy-client').to be_enabled
  end

  it 'Creates the push-jobs-client.rb' do
    expect(file 'C:/chef/push-jobs-client.rb').to be_file
    expect((file 'C:/chef/push-jobs-client.rb').content).to include('whitelist({"chef-client"=>"chef-client"})')
    expect((file 'C:/chef/push-jobs-client.rb').content).to include("LC_ALL='en_US.UTF-8'")
  end
end
