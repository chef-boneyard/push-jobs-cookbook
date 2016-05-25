require 'spec_helper'

describe 'push-jobs' do
  describe '::install' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.node.set['push_jobs']['chef']['node_name'] = 'Oscar'
      runner.node.set['push_jobs']['chef']['chef_server_url'] = 'https://chefserver.mycorp.co'
      runner.node.set['push_jobs']['allow_unencrypted'] = true
      runner.converge('recipe[push-jobs::config]')
    end

    it 'Creates the /etc/chef directory' do
      expect(chef_run).to create_directory '/etc/chef'
    end

    context '/etc/chef/push-jobs-client.rb file' do
      it 'has the specified environment variables' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content("LC_ALL=\'en_US.UTF-8\'")
      end

      it 'has the specified chef server url' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content("chef_server_url   \'https://chefserver.mycorp.co\'")
      end

      it 'has the specified node name' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content("node_name         \'Oscar\'")
      end

      it 'has the specified client key' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content("client_key        \'/etc/chef/client.pem\'")
      end

      it 'has the specified trusted certs entry' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content("trusted_certs_dir \'/etc/chef/trusted_certs\'")
      end

      it 'has the specified verify_api_cert entry' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('verify_api_cert   true')
      end

      it 'has the specified ssl_verify_mode' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('ssl_verify_mode   :verify_peer')
      end

      it 'has the specified whitelist' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('whitelist({"chef-client"=>"chef-client"})')
      end

      it 'has timestamps disabled' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('Mixlib::Log::Formatter.show_time = false')
      end

      it 'has allow_unencrypted set to true when attribute set' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('allow_unencrypted true')
      end
    end
  end

  describe '::windows' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
      runner.node.set['push_jobs']['chef']['node_name'] = 'Felix'
      runner.node.set['push_jobs']['chef']['chef_server_url'] = 'https://mychefserver.mycorp.co'
      runner.node.set['push_jobs']['allow_unencrypted'] = true
      runner.converge('recipe[push-jobs::config]')
    end

    context '/etc/chef/push-jobs-client.rb file' do
      it 'has the specified environment variables' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content("LC_ALL=\'en_US.UTF-8\'")
      end

      it 'has the specified chef server url' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content("chef_server_url   \'https://mychefserver.mycorp.co\'")
      end

      it 'has the specified node name' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content("node_name         \'Felix\'")
      end

      it 'has the specified client key' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content("client_key        \'c\:\\chef\\client.pem\'")
      end

      it 'has the specified trusted certs entry' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content("trusted_certs_dir \'c\:\\chef\\trusted_certs\'")
      end

      it 'has the specified verify_api_cert entry' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('verify_api_cert   true')
      end

      it 'has the specified ssl_verify_mode' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('ssl_verify_mode   :verify_peer')
      end

      it 'has the expected whitelist' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('whitelist({"chef-client"=>"chef-client"})')
      end

      it 'has timestamps disabled' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('Mixlib::Log::Formatter.show_time = true')
      end

      it 'has allow_unencrypted set to true when attribute set' do
        expect(chef_run).to render_file('/etc/chef/push-jobs-client.rb').with_content('allow_unencrypted true')
      end
    end
  end
end
