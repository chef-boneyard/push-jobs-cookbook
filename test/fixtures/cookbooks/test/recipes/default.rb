# we need a fake pem file or push-jobs won't start
if platform?('windows')
  directory 'C:\chefchef'

  template 'C:\chef\client.pem' do
    source 'client.pem.erb'
  end
else
  directory '/etc/chef'

  template '/etc/chef/client.pem' do
    source 'client.pem.erb'
  end
end

include_recipe 'push-jobs::default'
