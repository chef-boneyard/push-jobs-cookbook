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
