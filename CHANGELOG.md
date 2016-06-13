# push-jobs Cookbook CHANGELOG

This file is used to list changes made in each version of the push-jobs cookbook.

## v3.2.0 (2016-06-13)

- Ensure that runit jobs are deleted when switching to systemd or
  upstart

## v3.1.0 (2016-05-31)

- Fixed not_if statements that prevented the service from being enabled under systemd
- Fixed the service name under upstart to be chef-push-jobs-client not chef-push-jobs
- Updated the systemd unit file to restart on failure
- Added service inspec tests

## v3.0.0 (2016-05-31)

### Breaking changes

- The opscode-push-jobs-client service has been renamed chef-push-jobs-client. If the existing opscode-push-jobs-client service exists on your system it will be stopped/disabled and removed before installing the new service
- The install recipe will now install the chef-push-jobs-client service under systemd or upstart when running on nodes where those are the native init systems. Runit will continue to be used when running on sys-v init based nodes. You can continue to use runit by setting `default['push_jobs']['service_name']` to 'runit'
- The knife recipe has been removed. The push-jobs knife plugin can easily be installed on a workstation with a single chef_gem resource.
- Support for 'container' as an init system option has been removed

### Other changes

- Converted serverspec tests to inspec
- A new push_jobs_service provider has been added which supports setting up the push-jobs service in either upstart, systemd, or runit. The appropriate init system is selected automatically, but can also be forced by calling the full resource names. See the readme for additional properties and examples.
- Added Chefspec matchers for the custom resources
- Added Test Kitchen suites for the 1.0 release and the custom resources
- Added a requirement for at least Runit 1.2.0, which was the first version that supported RHEL systems

## v2.8.1 (2016-05-24)

- Add attribute for setting allow_unencrypted in the config via a new attribute, which is required when 2.X clients connect to the 1.X server
- Require at least Runit 1.2.0 cookbook to ensure compatibility with RHEL systems

## v2.8.0 (2016-05-19)

- Try a compatible package for unsupported platforms.

## v2.7.0 (2016-05-18)

- Allow installing push client 2.0 stable release

## v2.6.6 (2016-04-28)

- Fixed client key entry in config.
- Removed node name from the push-jobs-client.rb template
- Updated readme to properly list the supported / tested platforms

## v2.6.5 (2016-04-27)

- Update chef-ingredient version to install from packages.chef.io.

## v2.6.4 (2015-11-20)

- Fix version_from_manifest helper method.

## v2.6.3 (2015-11-10)

- Stopped the windows service from restarting with every CCR.

## v2.6.2 (2015-11-04)

- Added an attribute so we can enable timestamps on Windows.
- Fix pushy client service registration on Windows to correctly read config file.

## v2.6.1 (2015-10-21)

- # 56 - Replaced symbols with strings in recipe

## v2.6.0 (2015-10-13)

- Use chefdk version of berks for travis.
- # 54 Unbreak chef-ingredient installs, and improve version

  independence logic.

## v2.5.0 (2015-10-06)

- # 53 - Allow node_name and chef_server_url to be overridden

- # 49 - Support the name changes in 1.3x and 2.0 push client,

  especially on windows

- # 52 - More updates for newer rubocop and foodcritic

- # 50 - Allow ssl to be disabled

- Cleanups for travis testing and general hygiene

  - test on modern ruby
  - update kitchen.yml boxes
  - bump gem versions
  - rubocop update, use standard rules, misc fixes
  - foodcritic fixes
  - update README CONTRIBUTING
  - update urls/emails

## v2.4.2 (2015-09-08)

- # 42 - Windows push client to use own config

- # 43 - Include version in package name for idempotency

- # 46 - debug flag to logging level flag

## v2.4.1 (2015-07-29)

- # 41 - fix client path and node_name

## v2.4.0 (2015-07-20)

- Using chef-ingredient
- service_container recipe

## v2.3.0 (2015-06-18)

- Support environment variables in config file
- Correctly generate the chef client config.rb path on windows boxes.
- Greatly improved README

## v2.2.1 (2014-07-09)

- Refactored the service creation in the same manner as chef-client cookbook.
- Changed up the kitchen file to remove CentOS 5.9 and switched out Ubuntu 10.04 for Ubuntu 14.04.

## v2.2.0 (2014-03-07)

- Move config and service resources to separate recipes
- Add new helper methods for config path
- Update ChefSpec to v3 and specs to match

## v2.0.1 (2014-02-20)

- Make whitelist rendering is more robust
- Ensure `node['push_jobs']['whitelist']` is a Hash (or subclass thereof)

## v2.0.0 (2014-02-18)

- `node['push_jobs']['package_url']` and `node['push_jobs']['package_checksum']` are now required when installing the client package. The previous version of this cookbook automatically determined the proper values for the node if values were not supplied.

## v1.0.0 (2013-10-28)

- Initial release
