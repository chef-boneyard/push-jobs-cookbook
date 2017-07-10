#
# Cookbook:: push-jobs
# resource:: service_sysvinit
#
# Author:: Jennifer Davis <sigje@chef.io>
# Copyright:: 2017, Chef Software, Inc.
#

provides :push_jobs_service_sysvinit

provides :push_jobs_service, platform: 'debian' do |node|
  node['platform_version'].to_i == 7
end

provides :push_jobs_service, platform_family: 'rhel' do |node|
  node['platform_version'].to_i == 6
end

provides :push_jobs_service, platform_family: 'amazon'

action :start do
  delete_runit
  create_init

  service 'chef-push-jobs-client' do
    supports restart: true, status: true
    action :start
    subscribes :restart, "template[#{PushJobsHelper.config_path}]"
  end
end

action :stop do
  service 'chef-push-jobs-client' do
    supports status: true
    action :stop
    only_if { ::File.exist?('/etc/init.d/chef-push-jobs-client.conf') }
  end
end

action :restart do
  service 'chef-push-jobs-client' do
    supports restart: true, status: true
    action :restart
  end
end

action :enable do
  create_init

  service 'chef-push-jobs-client' do
    supports status: true
    action :enable
    only_if { ::File.exist?('/etc/init.d/chef-push-jobs-client') }
    subscribes :restart, "template[#{PushJobsHelper.config_path}]"
  end
end

action :disable do
  service 'chef-push-jobs-client' do
    supports status: true
    action :disable
    only_if { ::File.exist?('/etc/init.d/chef-push-jobs-client.conf') }
  end
end

action_class do
  def create_init
    include_recipe 'push-jobs::package'

    platform_lock_dir = value_for_platform_family(
      %w(rhel fedora suse) => '/var/lock/subsys',
      'debian' => '/var/lock',
      'default' => '/var/lock'
    )

    if platform_family?('rhel', 'fedora')
      if node['platform_version'].to_i < 6.0
        package 'redhat-lsb'
      else
        package 'redhat-lsb-core'
      end
    end

    template '/etc/init.d/chef-push-jobs-client' do
      mode '0755'
      source 'init_sysv.erb'
      cookbook 'push-jobs'
      variables(
        cli_command: PushJobsHelper.cli_command(node),
        lock_dir: platform_lock_dir,
        log_dir: "#{node['push_jobs']['logging_dir']}/push-jobs-client.log"
      )
    end
  end

  def delete_runit
    return unless ::File.exist?('/etc/sv/opscode-push-jobs-client/run')

    # disable the old service
    runit_service 'opscode-push-jobs-client' do
      action [:stop, :disable]
      not_if { ::File.zero?('/etc/sv/opscode-push-jobs-client/supervise/pid') }
    end

    # remove the old service configs
    directory '/etc/sv/opscode-push-jobs-client' do
      recursive true
      action :delete
    end

    # remove old init script link
    file '/etc/init.d/opscode-push-jobs-client' do
      action :delete
    end
  end
end
