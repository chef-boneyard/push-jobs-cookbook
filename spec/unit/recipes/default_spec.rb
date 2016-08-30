require 'spec_helper'

describe 'push-jobs::default' do
  context 'Ubuntu' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.node.normal['push_jobs']['package_url'] = 'http://foo.bar.com/opscode-push-jobs-client_1.0.0_x86_64.deb?key=value'
      runner.converge('recipe[push-jobs::default]')
    end

    it 'Does not raise an incompatibility error' do
      expect { chef_run }.not_to raise_error
    end

    it 'Includes the install recipe' do
      expect(chef_run).to include_recipe "#{described_cookbook}::install"
    end
  end
end
