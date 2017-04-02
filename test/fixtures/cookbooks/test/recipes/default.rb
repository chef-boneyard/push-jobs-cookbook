# we need a fake pem file or push-jobs won't start
unless platform?('windows')
  directory '/etc/chef'

  template '/etc/chef/client.pem' do
    source 'client.pem.erb'
  end
end

include_recipe 'push-jobs::default'
