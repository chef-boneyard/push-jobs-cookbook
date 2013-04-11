# opscode-push-jobs cookbook

Installs the Opscode Push Jobs client package and sets it up to run as
a service.

# Requirements

Requires Opscode Hosted Chef or Opscode Private Chef with the Push
Jobs feature.

* Chef: 11.4.0 or higher
* runit cookbook

## Platform

* Debian
* Ubuntu
* Windows

Tested on Debian 6.0.7, Ubuntu 10.04, 12.04, 12.10, and Windows 2008
R2. It may work on other debian or windows platform families with or
without modification.

Testing for Debian/Ubuntu can be done with Test Kitchen, see
TESTING.md in this repository.

# Usage

Set the appropriate attributes and include the default recipe in a
node's run list.

In order for the push jobs to be used, a whitelist of job names and
their commands must be set in the configuration file. This is
automatically generated from the attribute
`node['opscode_push_jobs']['whitelist']`. For example:

    node.set['opscode_push_jobs']['whitelist'] = {
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
      n.set["opscode_push_jobs"]["whitelist"]["ntpdate"] = "ntpdate -u time"
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

## default

The default recipe includes the appropriate recipe based on the node's
`platform_family`.

## config

While the push jobs client will use the Chef client configuration by
default, this recipe writes a separate configuration file that reads
in the `/etc/chef/client.rb`.

## debian

If the `node['opscode_push_jobs']['package_url']` attribute is set,
this recipe will download the Opscode Push Jobs Client package from
the URL. Otherwise, it assumes that the package is available from a
repository already configured (e.g., an internal repo).

The config recipe (above) will be included to write out the whitelist
of jobs as a separate configuration file.

It will also set up the Opscode Push Jobs Client daemon as a service
using `runit`. The default logger is used, so the log will be
`/var/log/opscode-push-jobs-client/current`.

## knife

If the `node['opscode_push_jobs']['gem_url']` attribute is set, this
recipe will download the knife-pushy gem to the system. Otherwise, it
assumes the gem is published to rubygems.org. Then the gem is
installed using `gem_package`.

Use this recipe on workstation systems that should manage running jobs
with the knife plugin.

## windows

The `node['opscode_push_jobs']['package_url']` attribute must be set
to use this recipe, as Windows does not have the concept of a package
manager with remote repositories. The URL will be used (with the
checksum attribute) to install the package using the `windows_package`
resource from the `windows` cookbook.

The config recipe (above) will be included to write out the whitelist
of jobs as a separate configuration file
(`c:\chef\push-jobs-client.rb`). The registry key for the client
service (`pushy-client`) will be updated to use this file.

The client service will be enabled and started.

# Author & License

* Author: Joshua Timberman (<joshua@opscode.com>)
* Copyright (c): 2013 Opscode, Inc. (<legal@opscode.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
