require 'spec_helper'

describe 'push-jobs::linux' do
  context 'windows' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012')
      runner.converge('recipe[push-jobs::linux]')
    end

    it 'Raises an incompatibility error' do
      expect { chef_run }.to raise_error 'This recipe does not support Windows'
    end
  end

  context 'linux with package_url' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '10.04')
      runner.node.set['push_jobs']['package_url'] = 'http://foo.bar.com/opscode-push-jobs-client_1.0.0_amd64.deb?key=value'
      runner.converge('recipe[push-jobs::linux]')
    end

    before { @package_file = 'opscode-push-jobs-client_1.0.0_amd64.deb' }

    it 'fetches the push jobs package' do
      expect(chef_run).to create_remote_file "#{Chef::Config[:file_cache_path]}/#{@package_file}"
    end

    it 'installs the chef_ingredient push-client' do
      expect(chef_run).to install_chef_ingredient('push-client').with(package_source: "#{Chef::Config[:file_cache_path]}/#{@package_file}")
    end

    it 'includes the config recipe' do
      expect(chef_run).to include_recipe("#{described_cookbook}::config")
    end

    it 'starts the opscode-push-jobs-client' do
      expect(chef_run).to start_runit_service 'opscode-push-jobs-client'
      expect(chef_run).to enable_runit_service 'opscode-push-jobs-client'
    end
  end

  # These fail because PushJobsHelper.find_installed_version/version_from_manifest can't find
  # an installed version.
  # I'd like to stub those calls, but the following don't seem to alter the call find_installed_version in service_runit.
  # allow(PushJobsHelper).to receive(:version_from_manifest).with(anything).and_return("1.1.666")
  # allow(PushJobsHelper).to receive(:find_installed_version).with(anything, anything).and_return("1.1.666")
  # But strangely enough the alter the calls if they are made in the spec.
  #
  context 'linux without package_url' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '10.04')
      runner.converge('recipe[push-jobs::linux]')
    end

    xit 'installs the chef_ingredient push-client' do
      expect(chef_run).to install_chef_ingredient('push-client')
    end

    xit 'includes the config recipe' do
      expect(chef_run).to include_recipe("#{described_cookbook}::config")
    end

    xit 'starts the opscode-push-jobs-client' do
      expect(chef_run).to start_runit_service 'opscode-push-jobs-client'
      expect(chef_run).to enable_runit_service 'opscode-push-jobs-client'
    end
  end
end
