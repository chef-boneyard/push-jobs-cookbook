name             "opscode-push-jobs"
maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs the Opscode Push Jobs Client"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.0"

supports "ubuntu"
supports "windows"
depends "runit"
depends "windows"

attribute("opscode_push_jobs/package_url",
  :description => "URL to a client package to download for installing Opscode Push Job Client")

attribute("opscode_push_jobs/gem_url",
  :description => "URL to the knife plugin gem file")

attribute("opscode_push_jobs/whitelist",
  :description => "Hash of whitelist jobs for the push client configuration")
