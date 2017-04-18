describe 'chef-push-jobs package' do
  it 'Installs the push jobs client' do
    expect(file 'C:/opscode/pushy/bin/pushy-client.bat').to be_file
  end
end

describe 'push client service' do
  it 'should enable and start service' do
    expect(service 'pushy-client').to be_installed
    expect(service 'pushy-client').to be_enabled
  end
end

describe file('C:/chef/push-jobs-client.rb') do
  it { should be_file }
  its('content') { should match /whitelist\({"chef-client"=>"chef-client"}\)/ }
  its('content') { should match /LC_ALL='en_US.UTF-8'/ }
  its('content') { should match /allow_unencrypted false/ }
end
