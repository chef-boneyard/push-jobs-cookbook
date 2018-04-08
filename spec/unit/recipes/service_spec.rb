# frozen_string_literal: true

require 'spec_helper'

shared_context 'chef run' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform_details)
    runner.node.normal['push_jobs']['package_url'] = pkg_url
    runner.converge(described_recipe)
  end
end

shared_examples 'creates push-jobs service' do
  it 'will enable the push_jobs_service resource' do
    expect(chef_run).to enable_push_jobs_service('push-jobs')
  end
  it 'will start the push_jobs_service resource' do
    expect(chef_run).to start_push_jobs_service('push-jobs')
  end
  it 'will include the push-jobs::package recipe' do
    expect(chef_run).to include_recipe('push-jobs::package')
  end
  it 'will create the push-jobs client service file' do
    expect(chef_run).to create_template(service_file)
  end
  it 'restats the push-jobs service' do
    t = chef_run.template(service_file)
    expect(t).to notify('service[chef-push-jobs-client]').to(:restart).immediately
  end
end

shared_examples 'calls the push-jobs service systemd resource' do
  it 'reloads the systemd service' do
    template = chef_run.template(service_file)
    expect(template).to notify('execute[reload_unit_file]').to(:run).immediately
  end
end

describe 'push-jobs::service' do
  context 'when platform is suse version 11.4' do
    let(:platform_details) do
      { platform: 'suse', version: '11.4', step_into: 'push_jobs_service' }
    end
    let(:pkg_url) { 'http://foo.bar.com/push-jobs-client-2.4.5-1.x86_64.rpm' }
    let(:service_file) { '/etc/init.d/chef-push-jobs-client' }
    include_context 'chef run'
    include_examples 'creates push-jobs service'
  end

  context 'when platform is suse version 12.3' do
    let(:platform_details) do
      { platform: 'suse', version: '12.3', step_into: 'push_jobs_service' }
    end
    let(:pkg_url) { 'http://foo.bar.com/push-jobs-client_2.4.5-1.x86_64.rpm' }
    let(:service_file) { '/etc/systemd/system/chef-push-jobs-client.service' }
    include_context 'chef run'
    include_examples 'creates push-jobs service'
    include_examples 'calls the push-jobs service systemd resource'
  end
end
