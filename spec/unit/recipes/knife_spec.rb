require 'spec_helper'

describe 'push-jobs::knife' do
  cached(:chef_run) do
    runner = ChefSpec::ServerRunner.new
    runner.node.set['push_jobs']['gem_url'] = 'http://foo.bar.com/knife-pushy-0.1.gem?key=value'
    runner.converge('recipe[push-jobs::knife]')
  end

  package_file = 'knife-pushy-0.1.gem'

  it 'fetches the push jobs knife plugin gem' do
    expect(chef_run).to create_remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}"
  end

  it 'installs push jobs knife plugin gem' do
    expect(chef_run).to install_gem_package package_file
  end
end
