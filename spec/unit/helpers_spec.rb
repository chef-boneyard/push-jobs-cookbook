require "#{File.dirname(File.dirname(File.dirname(__FILE__)))}/libraries/helpers"

describe 'PushJobsHelper' do
  let(:default_node) { { 'push_jobs' => {} } }
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

  it 'parse_version method should return empty string' do
    url = 'http://foo-1-2.bar.com/jobs-client-renamed.msi'
    expect(PushJobsHelper.parse_version(default_node, url)).to match nil
  end

  it 'parse_version method should return correct version for stable version' do
    url = 'http://foo-3.bar.com/opscode-push-jobs-client-windows-1.1.5-1.windows.msi?key=value'
    expect(PushJobsHelper.parse_version(default_node, url)).to match '1.1.5'
  end

  it 'parse_version method should return correct version for non-GA version' do
    url = 'https://foo-4.bar.com/push-jobs-client-2.0.0-alpha.1-1.msi'
    expect(PushJobsHelper.parse_version(default_node, url)).to match '2.0.0'
  end

  it 'parse_version method should let node["push_jobs"]["version"]' do
    node = { 'push_jobs' => { 'package_version' => '1.2.3' } }
    url = 'https://foo-4.bar.com/push-jobs-client-2.0.0-alpha.1-1.msi'
    expect(PushJobsHelper.parse_version(node, url)).to match '1.2.3'
  end
end
