require 'spec_helper'

describe 'push-jobs' do
  describe '::install' do
    cached(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '10.04')
      runner.converge('recipe[push-jobs::config]')
    end

    it 'Creates the /etc/chef directory' do
      expect(chef_run).to create_directory '/etc/chef'
    end

    context '/etc/chef/push-jobs-client.rb file' do
      it 'has the expected whitelist' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('whitelist({"chef-client"=>"chef-client"})')
      end

      it 'has timestamps disabled' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('Mixlib::Log::Formatter.show_time = false')
      end
    end
  end

  describe '::windows' do
    cached(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2')
      runner.converge('recipe[push-jobs::config]')
    end

    context '/etc/chef/push-jobs-client.rb file' do
      it 'has the expected whitelist' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('whitelist({"chef-client"=>"chef-client"})')
      end

      it 'has timestamps disabled' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('Mixlib::Log::Formatter.show_time = true')
      end
    end
  end
end
