require 'spec_helper'

describe 'push-jobs::default' do
  context 'Ubuntu' do
    cached(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04')
      runner.node.set['push_jobs']['package_url'] = 'http://foo.bar.com/opscode-push-jobs-client_x86_64.deb?key=value'
      runner.converge('recipe[push-jobs::default]')
    end

    it 'Does not raise an incompatibility error' do
      expect { chef_run }.not_to raise_error
    end

    it 'Includes the linux recipe' do
      expect(chef_run).to include_recipe "#{described_cookbook}::linux"
    end
  end

  context 'Windows' do
    cached(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2')
      runner.node.set['push_jobs']['package_url'] = 'http://foo.bar.com/opscode-push-jobs-client-1.2.3-x86_64.msi?key=value'
      runner.converge('recipe[push-jobs::default]')
    end

    it 'Does not raise an incompatibility error' do
      expect { chef_run }.not_to raise_error
    end

    it 'Includes the Windows recipe' do
      expect(chef_run).to include_recipe "#{described_cookbook}::windows"
    end
  end
end
