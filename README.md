# opscode-push-jobs cookbook

Installs the Opscode Push Jobs client package and sets it up to run as
a service under runit.

# Requirements

Requires Opscode Hosted Chef or Opscode Private Chef with the Push
Jobs feature.

* Chef: 11.4.0 or higher
* runit cookbook
* Ubuntu platform

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

In a future release, an LWRP will be added to automatically add push
jobs.

# Attributes

Attributes are documented in metadata.rb. See `attributes/default.rb`
for default values.

# Recipes

## default

The default recipe installs the client by downloading a package URL if
the attribute is set, or otherwise from a package repository.

While the push jobs client will use the Chef client configuration by
default, this recipe writes a separate configuration file that reads
in the `/etc/chef/client.rb`.

# Author & License

* Author: Joshua Timberman (<joshua@opscode.com>)
* Copyright (c): 2013 Opscode, Inc. (<legal@opscode.com>)

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
