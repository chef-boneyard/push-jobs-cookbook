require "#{File.dirname(File.dirname(File.dirname(__FILE__)))}/libraries/helpers"

describe 'PushJobsHelper' do
  let(:default_node) { { 'push_jobs' => {} } }
  it 'package_file method should return a valid package filename' do
    package_url = 'http://foo.bar.com/opscode-push-jobs-client_amd64.deb?key=value'
    expect(PushJobsHelper.package_file(package_url)).to match 'opscode-push-jobs-client_amd64.deb'
  end

  it 'config_dir method should return a valid pathname' do # This could be redundant
    expect(PushJobsHelper.config_dir).to match Chef::Config.platform_specific_path('/etc/chef')
  end

  it 'config_path method should return a valid filename' do # This could be redundant
    expect(PushJobsHelper.config_path).to match "#{Chef::Config.platform_specific_path('/etc/chef')}/push-jobs-client.rb"
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

  it 'chef_server_url method should return node["push_jobs"]["chef"]["chef_server_url"] if set' do
    node = { 'push_jobs' => { 'chef' => { 'chef_server_url' => 'https://chefserver.mycorp.co' } } }
    expect(PushJobsHelper.chef_server_url(node)).to match 'https://chefserver.mycorp.co'
  end

  it 'node_name method should return node["push_jobs"]["chef"]["node_name"] if set' do
    node = { 'push_jobs' => { 'chef' => { 'node_name' => 'Felix' } } }
    expect(PushJobsHelper.node_name(node)).to match 'Felix'
  end

  describe 'family_by_version' do
    it 'returns the family name for the corresponding version' do
      expect(PushJobsHelper.family_by_version('1.0.0')).to eq :family_1_0
      expect(PushJobsHelper.family_by_version('1.1.5')).to eq :family_1_0
      expect(PushJobsHelper.family_by_version('1.3.3')).to eq :family_1_3
      expect(PushJobsHelper.family_by_version('1.3.4')).to eq :family_1_3
      expect(PushJobsHelper.family_by_version('2.0.0-alpha')).to eq :family_2_0
      expect(PushJobsHelper.family_by_version('2.1.0')).to eq :family_2_0
    end

    it 'raises an error for non-recognized versions' do
      version = '3.0.0-awesome'
      error = "No info for version '#{version}'"
      expect { PushJobsHelper.family_by_version(version) }.to raise_error(RuntimeError, error)
    end
  end
end
