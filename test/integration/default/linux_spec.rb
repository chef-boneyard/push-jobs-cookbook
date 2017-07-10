describe 'chef-push-jobs package' do
  it 'should be installed' do
    expect(file('/opt/push-jobs-client/bin/pushy-client')).to exist
    expect(file('/opt/push-jobs-client/bin/pushy-service-manager')).to exist
  end
end

describe file('/etc/chef/push-jobs-client.rb') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp 0644 }
  its('content') { should match /whitelist\({"chef-client"=>"chef-client"}\)/ }
  its('content') { should match /LC_ALL='en_US.UTF-8'/ }
  its('content') { should match /allow_unencrypted false/ }
end

if os.redhat? || os.debian? || os[:family] == 'amazon'
  describe service('chef-push-jobs-client') do
    it { should be_enabled }
    it { should be_running }
  end
else
  describe command('sv status chef-push-jobs-client') do
    its('stdout') { should match /run: chef-push-jobs-client|want up/ }
  end
end
