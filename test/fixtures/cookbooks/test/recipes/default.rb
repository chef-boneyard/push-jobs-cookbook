# we need a fake pem file or push-jobs won't start
unless platform?('windows')
  directory '/etc/chef'

  cookbook_file '/etc/chef/client.pem' do
  	source 'client.pem'
  end
else
  directory 'C:\chef'
  cookbook_file 'C:\chef\client.pem' do
    source 'client.pem'
  end
end

include_recipe 'push-jobs::default'
