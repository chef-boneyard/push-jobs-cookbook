require 'spec_helper'

describe 'push-jobs' do
  shared_examples_for 'has common configuration' do
    it 'has the specified environment variables' do
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content("LC_ALL=\'en_US.UTF-8\'")
    end

    it 'has the specified chef server url' do
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content("chef_server_url   \'https://chefserver.mycorp.co\'")
    end

    it 'has the specified verify_api_cert entry' do
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('verify_api_cert   true')
    end

    it 'has the specified ssl_verify_mode' do
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('ssl_verify_mode   :verify_peer')
    end

    it 'has the expected whitelist' do
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('whitelist({"chef-client"=>"chef-client"})')
    end

    it 'has allow_unencrypted set to true when attribute set' do
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('allow_unencrypted true')
    end
  end

  shared_examples_for 'has proxy configuration' do
    it 'has an http proxy configured' do
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('http_proxy \'http://proxy.mycorp.co\'')
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('http_proxy_user \'foo\'')
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('http_proxy_pass \'bar\'')
    end

    it 'has an https proxy configured' do
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('https_proxy \'https://proxy.mycorp.co\'')
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('https_proxy_user \'biz\'')
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('https_proxy_pass \'baz\'')
    end

    it 'has no proxy configured' do
      expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('no_proxy \'127.0.0.1\'')
    end
  end

  describe '::install' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.node.normal['push_jobs']['chef']['node_name'] = 'Oscar'
      runner.node.normal['push_jobs']['chef']['chef_server_url'] = 'https://chefserver.mycorp.co'
      runner.node.normal['push_jobs']['allow_unencrypted'] = true
      runner.node.normal['push_jobs']['proxy']['http']['url'] = 'http://proxy.mycorp.co'
      runner.node.normal['push_jobs']['proxy']['http']['user'] = 'foo'
      runner.node.normal['push_jobs']['proxy']['http']['pass'] = 'bar'
      runner.node.normal['push_jobs']['proxy']['https']['url'] = 'https://proxy.mycorp.co'
      runner.node.normal['push_jobs']['proxy']['https']['user'] = 'biz'
      runner.node.normal['push_jobs']['proxy']['https']['pass'] = 'baz'
      runner.node.normal['push_jobs']['no_proxy'] = '127.0.0.1'
      runner.converge('recipe[push-jobs::config]')
    end

    before { @config_dir = Chef::Config.platform_specific_path('/etc/chef') }

    it 'Creates the /etc/chef directory in Linux' do
      expect(chef_run).to create_directory(@config_dir)
    end

    context '/etc/chef/push-jobs-client.rb file' do
      it 'has the specified node name' do
        expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content("node_name         \'Oscar\'")
      end

      it 'has the specified client key' do
        expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content("client_key        \'/etc/chef/client.pem\'")
      end

      it 'has the specified trusted certs entry' do
        expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content("trusted_certs_dir \'/etc/chef/trusted_certs\'")
      end

      it 'has timestamps disabled' do
        expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('Mixlib::Log::Formatter.show_time = false')
      end

      it_behaves_like 'has common configuration'
      it_behaves_like 'has proxy configuration'
    end
  end

  describe '::windows' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
      runner.node.normal['push_jobs']['chef']['node_name'] = 'Felix'
      runner.node.normal['push_jobs']['chef']['chef_server_url'] = 'https://chefserver.mycorp.co'
      runner.node.normal['push_jobs']['allow_unencrypted'] = true
      runner.node.normal['push_jobs']['proxy']['http']['url'] = 'http://proxy.mycorp.co'
      runner.node.normal['push_jobs']['proxy']['http']['user'] = 'foo'
      runner.node.normal['push_jobs']['proxy']['http']['pass'] = 'bar'
      runner.node.normal['push_jobs']['proxy']['https']['url'] = 'https://proxy.mycorp.co'
      runner.node.normal['push_jobs']['proxy']['https']['user'] = 'biz'
      runner.node.normal['push_jobs']['proxy']['https']['pass'] = 'baz'
      runner.node.normal['push_jobs']['no_proxy'] = '127.0.0.1'
      runner.converge('recipe[push-jobs::config]')
    end

    before { @config_dir = Chef::Config.platform_specific_path('/etc/chef') }

    it 'Creates the /etc/chef directory in Windows' do
      expect(chef_run).to create_directory(@config_dir)
    end

    context 'C:\chef\push-jobs-client.rb file' do
      it 'has the specified node name' do
        expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content("node_name         \'Felix\'")
      end

      it 'has the specified client key' do
        expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content("client_key        \'C\:\\chef\\client.pem\'")
      end

      it 'has the specified trusted certs entry' do
        expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content("trusted_certs_dir \'C\:\\chef\\trusted_certs\'")
      end

      it 'has timestamps enabled' do
        expect(chef_run).to render_file("#{@config_dir}/push-jobs-client.rb").with_content('Mixlib::Log::Formatter.show_time = true')
      end

      it_behaves_like 'has common configuration'
      it_behaves_like 'has proxy configuration'
    end
  end
end
