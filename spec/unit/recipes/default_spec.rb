require 'spec_helper'

describe 'push-jobs::default' do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new
    runner.converge('recipe[push-jobs::default]')
  end

  it 'Logs the incompatibility error message when the OS is unsupported' do
    expect(chef_run).to log 'This cookbook is currently only supported on Windows, Debian-family linux, and Redhat-family linux.'
  end

  context 'Ubuntu' do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04')
      runner.converge('recipe[push-jobs::default]')
    end

    it 'Does not log the incompatibility error message' do
      expect(chef_run).not_to log 'This cookbook is currently only supported on Windows, Debian-family linux, and Redhat-family linux.'
    end

    it 'Includes the linux recipe' do
      expect(chef_run).to include_recipe "#{described_cookbook}::linux"
    end
  end

  context 'Windows' do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new(platform: 'windows', version: '2008R2')
      runner.node.set['push_jobs']['package_url'] = 'http://foo.bar.com/opscode-push-jobs-client_x86_64.msi?key=value'
      runner.converge('recipe[push-jobs::default]')
    end

    it 'Does not log the incompatibility error message' do
      expect(chef_run).not_to log 'This cookbook is currently only supported on Windows, Debian-family linux, and Redhat-family linux.'
    end

    it 'Includes the Windows recipe' do
      expect(chef_run).to include_recipe "#{described_cookbook}::windows"
    end
  end

end