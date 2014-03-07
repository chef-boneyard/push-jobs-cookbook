require "#{File.dirname(File.dirname(File.dirname(__FILE__)))}/libraries/helpers"

describe 'PushJobsHelper' do

  it 'package_file method should return a valid package filename' do
    package_url = 'http://foo.bar.com/opscode-push-jobs-client_amd64.deb?key=value'
    expect(PushJobsHelper.package_file(package_url)).to match 'opscode-push-jobs-client_amd64.deb'
  end

  it 'config_dir method should return a valid pathname' do
    expect(PushJobsHelper.config_dir).to match '/etc/chef'
  end

  it 'config_path method should return a valid filename' do
    expect(PushJobsHelper.config_path).to match '/etc/chef/push-jobs-client.rb'
  end

end
