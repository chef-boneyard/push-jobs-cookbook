# push-jobs cookbook

Installs the Chef Push Jobs client package and sets it up to run as
a service.

The official documentation is on
[docs.chef.io](http://docs.chef.io/push_jobs.html)

# Requirements

Requires Enterprise Chef with the Push
Jobs feature.

* Chef: 11.4.0 or higher
* runit cookbook
* windows cookbook

## Platform

* Debian
* Ubuntu
* Windows

Tested on Ubuntu 10.04, 12.04, CentOS 6.4, and Windows 2008
R2. It may work on other debian, rhel, or windows platform families with or
without modification.

Testing for Ubuntu/CentOS can be done with Test Kitchen, see TESTING.md in this repository.

# Install the Workstation
To set up the Chef push jobs workstation, install the knife push plugin. The simplest way to install the plugin is by entering the following command at a shell prompt:

    chef gem install knife-push  

Alternatives to chef gem install be found at https://docs.chef.io/plugin_knife_custom.html#install-a-plugin. Once installed, the following subcommands will be available: 
* knife job list
* knife job start
* knife job status.

# Usage

Set the appropriate attributes and include the default recipe in a
node's run list. The URL to the package to install and its SHA256
checksum are required so the package may be retrieved. For example:

    node.set['push_jobs']['package_url'] = "http://www.example.com/pkgs/opscode-push-jobs-client_1.0.1-1.ubuntu.12.04_amd64.deb"
    node.set['push_jobs']['package_checksum'] = "a-sha256-checksum"

In order for the push jobs to be used, a whitelist of job names and
their commands must be set in the configuration file. This is
automatically generated from the attribute
`node['push_jobs']['whitelist']`. This attribute must be a Hash. For
example:

    node.set['push_jobs']['whitelist'] = {
      "chef-client" => "chef-client",
      "apt-get-update" => "apt-get update"
    }

As this is an attribute, interesting uses arise from orchestrating a
Chef Client run. Assuming the above is present on the node prior to
running the recipe, run Chef Client with this command from the local
workstation:

    knife job start chef-client A_NODE_NAME

New jobs can be added to the whitelist simply by creating attributes.
This can be done with `knife exec`:

    knife exec -E 'nodes.transform("name:A_NODE_NAME") do |n|
      n.set["push_jobs"]["whitelist"]["ntpdate"] = "ntpdate -u time"
    end'

Then, run the chef-client job, and then the ntpdate job:

    knife job start chef-client A_NODE_NAME
    knife job start ntpdate A_NODE_NAME

In a future release, an LWRP may be added to automatically add push
jobs.

# Attributes

Attributes are documented in metadata.rb. See `attributes/default.rb`
for default values.

# Recipes

There are several recipes in this cookbook, so they can be used all
together (include the `default` recipe), or as necessary.

## default

The default recipe includes the appropriate recipe based on the node's
`platform_family`. It will `raise` an error if:

- The package URL and checksum attributes are not set.
- The whitelist is not a Hash.
- The node's platform is not supported.

## config

This recipe ensures the platform-specific configuration directory
(`/etc/chef`) is created, and renders the configuration file
(`push-jobs-client.rb`) using the `whitelist` attribute.
Any environment variables can be set using `environment_variables`
attribute with key value pairs.
You can provide your own `push-jobs-client.rb.erb` template file in
a wrapper cookbook and set the `['config']['template_cookbook']`
attribute to the name of that wrapper cookbook.


The path to the configuration file is set using the `PushJobsHelper`
module's `#config_path` method. This is done to ensure the correct
file path is used on Linux and Windows platforms, as it uses
`Chef::Config`'s `#platform_specific_path` method.

## linux

The `node['push_jobs']['package_url']` attribute must be set for this
recipe to download the Chef Push Jobs Client package from the URL.

## knife

If the `node['push_jobs']['gem_url']` attribute is set, this
recipe will download the knife-pushy gem to the system.

Use this recipe on workstation systems that should manage running jobs
with the knife plugin.

## service

This recipe is responsible for handling the service resource based on
the node's platform. On Linux (Debian and RHEL families), it will
create a `runit` service. The default logger is used, and the log will
be `/var/log/push-jobs-client/current`. On Windows, it will add a
registry key for the Push Jobs client, and manage the Windows service.

The service resources expect to be restarted if the configuration
template is changed, using `subscribes` notification.

## windows

The `node['push_jobs']['package_url']` attribute must be set
to use this recipe, as Windows does not have the concept of a package
manager with remote repositories. The URL will be used (with the
checksum attribute) to install the package using the `windows_package`
resource from the `windows` cookbook.

# Client Connection Configuration

The push job client establishes a command and heartbeat channel to the
push server over **tcp**.  The tcp connection information is read from 
the Chef Server upon startup of the push client service from an endpoint
similar to the following:

    https://private-chef-server/organizations/org1/pushy/config/

The connection information for the push server is established when the
push server is installed and the Chef Server is reconfigured.  In the case
the Chef Server is not providing the correct push server configuration, 
please verify hostnames are correct and that both the push server and 
Chef Server have been reconfigured.

# Verify Push Jobs Client Connection

If the push-jboss client has been successfully installed on a node, the 
client should be able to successfully respond to a `knife job` directed
to the node.  If the node is not responding correctly, please consult the 
logs `/var/log/push-jobs-client/current` (for Debian and Rhel families) and
look for entries similar to the following:

    INFO: [pclient] Starting client ...
    INFO: [pclient] Retrieving configuration from https://private-chef-server/organizations/org1/pushy/config/pc_6_1 ...
    INFO: [pclient] Connecting to command channel at tcp://private-chef-server:10002
    INFO: [pclient] Listening for server heartbeat at tcp://private-chef-server:10000
    INFO: [pclient] Started client.

# Author & License

* Author: Joshua Timberman (<joshua@getchef.com>)
* Author: Charles Johnson (<charles@getchef.com>)
* Author: Christopher Maier (<cm@getchef.com>)
* Copyright: 2013-2014 Chef Software, Inc. (<legal@getchef.com>)

```text
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
