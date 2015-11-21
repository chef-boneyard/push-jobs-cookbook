push-jobs Cookbook CHANGELOG
============================
This file is used to list changes made in each version of the push-jobs cookbook.

v2.6.4 (2015-11-20)
-------------------
- Fix version_from_manifest helper method.

v2.6.3 (2015-11-10)
-------------------
- Stopped the windows service from restarting with every CCR.

v2.6.2 (2015-11-04)
-------------------
- Added an attribute so we can enable timetsamps on Windows.
- Fix pushy client service registration on Windows to correctly read config file.

v2.6.1 (2015-10-21)
-------------------
- #56 - Replaced symbols with strings in recipe

v2.6.0 (2015-10-13)
-------------------
- Use chefdk version of berks for travis.
- #54 Unbreak chef-ingredient installs, and improve version
  independence logic.

v2.5.0 (2015-10-06)
-------------------
- #53 - Allow node\_name and chef\_server\_url to be overridden
- #49 - Support the name changes in 1.3x and 2.0 push client,
  especially on windows
- #52 - More updates for newer rubocop and foodcritic
- #50 - Allow ssl to be disabled
- Cleanups for travis testing and general hygiene
  - test on modern ruby
  - update kitchen.yml boxes
  - bump gem versions
  - rubocop update, use standard rules, misc fixes
  - foodcritic fixes
  - update README CONTRIBUTING
  - update urls/emails


v2.4.2 (2015-09-08)
-------------------
- #42 - Windows push client to use own config
- #43 - Include version in package name for idempotency
- #46 - debug flag to logging level flag

v2.4.1 (2015-07-29)
-------------------
- #41 - fix client path and node_name

v2.4.0 (2015-07-20)
-------------------
- Using chef-ingredient
- service_container recipe

v2.3.0 (2015-06-18)
-------------------
- Support environment variables in config file
- Correctly generate the chef client config.rb path on windows boxes.
- Greatly improved README

v2.2.1 (2014-07-09)
-------------------
- Refactored the service creation in the same manner as chef-client cookbook.
- Changed up the kitchen file to remove CentOS 5.9 and switched out Ubuntu 10.04 for Ubuntu 14.04.

v2.2.0 (2014-03-07)
-------------------
- Move config and service resources to separate recipes
- Add new helper methods for config path
- Update ChefSpec to v3 and specs to match

v2.0.1 (2014-02-20)
-------------------
- Make whitelist rendering is more robust
- Ensure `node['push_jobs']['whitelist']` is a Hash (or subclass
  thereof)

v2.0.0 (2014-02-18)
-------------------
- `node['push_jobs']['package_url']` and
  `node['push_jobs']['package_checksum']` are now required when
  installing the client package.  The previous version of this
  cookbook automatically determined the proper values for the node if
  values were not supplied.

v1.0.0 (2013-10-28)
-------------------
- Initial release
