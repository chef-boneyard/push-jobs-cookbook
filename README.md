# push-jobs cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/push-jobs.svg?branch=master)](http://travis-ci.org/chef-cookbooks/push-jobs) [![Cookbook Version](https://img.shields.io/cookbook/v/push-jobs.svg)](https://supermarket.chef.io/cookbooks/push-jobs)

Installs the Chef Push client package and sets it up to run as a service.

The official documentation is on [docs.chef.io](https://docs.chef.io/push_jobs.html)

## Requirements

Requires Chef Server with the Chef Push Server add-on.

### Platforms

- Debian/Ubuntu
- Windows

Tested with Test Kitchen suites on Ubuntu 12.04/14.04/16.04, CentOS 6/7, and Windows 2012 R2\. It may work on other debian, rhel, or windows platform families with or without modification.

### Chef

- Chef 12+

### Cookbooks

- [runit](https://supermarket.chef.io/cookbooks/runit)
- [windows](https://supermarket.chef.io/cookbooks/windows)
- [chef-ingredient](https://supermarket.chef.io/cookbooks/chef-ingredient)
- [compat_resource](https://supermarket.chef.io/cookbooks/compat_resource)

## Usage

Include the default recipe in a node's run list. On Windows, the URL to the package to install and its SHA256 checksum are required so the package may be retrieved. For example:

```ruby
node.default['push_jobs']['package_url'] = "http://www.example.com/pkgs/opscode-push-jobs-client-windows-1.1.5-1.windows.msi"
node.default['push_jobs']['package_checksum'] = "a-sha256-checksum"
```

Set a whitelist of job names and their commands in the configuration file. This is automatically generated from the `node['push_jobs']['whitelist']` attribute Hash, such as:

```ruby
node.default['push_jobs']['whitelist'] = {
  "chef-client" => "chef-client",
  "apt-get-update" => "apt-get update"
}
```

As this is an attribute, interesting uses arise from orchestrating a Chef Client run. Assuming the above is present on the node prior to running the recipe, run Chef Client with this command from the local workstation:

```
knife job start chef-client A_NODE_NAME
```

New jobs can be added to the whitelist simply by creating attributes. This can be done with `knife exec`:

```
knife exec -E 'nodes.transform("name:A_NODE_NAME") do |n|
  n.set["push_jobs"]["whitelist"]["ntpdate"] = "ntpdate -u time"
end'
```

Then, run the chef-client job, and then the ntpdate job:

```
knife job start chef-client A_NODE_NAME
knife job start ntpdate A_NODE_NAME
```

### Enabling 1.X Server Compatibility

If you're running the 2.X push jobs client with the 1.X server you'll need to set allow_unencrypted to true with this attribute:

```ruby
node.default['push_jobs']['allow_unencrypted'] = true
```

## Attributes

See `attributes/default.rb` for default values.

## Recipes

There are several recipes in this cookbook, so they can be used all together (include the `default` recipe), or as necessary.

### default

The default recipe includes the appropriate recipe based on the node's `platform_family`. It will `raise` an error if:

- The package URL and checksum attributes are not set on Windows
- The whitelist is not a Hash.
- The node's platform is not supported.

### config

This recipe ensures the platform-specific configuration directory (`/etc/chef`) is created, and renders the configuration file (`push-jobs-client.rb`) using the `whitelist` attribute. Any environment variables can be set using `environment_variables` attribute with key value pairs. You can provide your own `push-jobs-client.rb.erb` template file in a wrapper cookbook and set the `['config']['template_cookbook']` attribute to the name of that wrapper cookbook.

The path to the configuration file is set using the `PushJobsHelper` module's `#config_path` method. This is done to ensure the correct file path is used on Linux and Windows platforms, as it uses `Chef::Config`'s `#platform_specific_path` method.

### service

This recipe is responsible for handling the service resource based on the node's platform. On Linux (Debian and RHEL families), it will create a `runit`, `upstart`, or `systemd` service. `upstart` and `systemd` will be used where those are the native init system for your distro. If neither are available or `default['push_jobs']['init_style']` is set to `runit` then runit will be installed and the service will use runit. On Windows nodes, the recipe will add a registry key for the Chef Push client, and manage the Windows service.

The service resources expect to be restarted if the configuration template is changed, using `subscribes` notification.

## Client Connection Configuration

The push job client establishes a command and heartbeat channel to the push server over **tcp**. The tcp connection information is read from the Chef Server upon startup of the push client service from an endpoint similar to the following:

```
https://private-chef-server/organizations/org1/pushy/config/
```

The connection information for the push server is established when the push server is installed and the Chef Server is reconfigured. In the case the Chef Server is not providing the correct push server configuration, please verify hostnames are correct and that both the push server and Chef Server have been reconfigured.

## Verify Push Jobs Client Connection

If the push client has been successfully installed on a node, the client should be able to successfully respond to a `knife job` directed to the node. If the node is not responding correctly, please consult the logs `/var/log/push-jobs-client/current` (for Debian and Rhel families) and look for entries similar to the following:

```
INFO: [pclient] Starting client ...
INFO: [pclient] Retrieving configuration from https://private-chef-server/organizations/org1/pushy/config/pc_6_1 ...
INFO: [pclient] Connecting to command channel at tcp://private-chef-server:10002
INFO: [pclient] Listening for server heartbeat at tcp://private-chef-server:10000
INFO: [pclient] Started client.
```

## License & Authors

- Author: Joshua Timberman ([joshua@chef.io](mailto:joshua@chef.io))
- Author: Charles Johnson ([charles@chef.io](mailto:charles@chef.io))
- Author: Christopher Maier ([cm@chef.io](mailto:cm@chef.io))

```text
Copyright:: 2009-2016, Chef Software, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
