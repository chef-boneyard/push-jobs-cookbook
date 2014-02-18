This cookbook includes support for running tests via Test Kitchen (1.0). This has some requirements.

1. You must be using the Git repository, rather than the downloaded cookbook from the Chef Community Site.
2. You must have Vagrant 1.1 installed.
3. You must have a "sane" Ruby 1.9.3 environment.

Once the above requirements are met, install the additional requirements:

Install the berkshelf plugin for vagrant, and berkshelf to your local Ruby environment.

    vagrant plugin install vagrant-berkshelf
    gem install berkshelf

Install Test Kitchen 1.0

    gem install test-kitchen

Install the Vagrant driver for Test Kitchen.

    gem install kitchen-vagrant

Currently, it is necessary to supply both
`node['push_jobs']['package_url']` and
`node['push_jobs']['package_checksum']` attributes.  See the
`.kitchen.local.yml.example` file for how you can do this.  Simply
copy that file to `.kitchen.local.yml` and edit it as appropriate.

Once the above are installed, you should be able to run Test Kitchen:

    kitchen list
    kitchen test

This cookbook has the following Test-Kitchen coverage:

| Test Coverage  | Ubuntu 12.04  | Ubuntu 10.04 | Centos 6.4 | Centos 5.9 | Windows 2008 R2 |
| -------------- |:-------------:|:------------:|:----------:|:----------:|:---------------:|
| default        | **Y**         | **Y**        | **Y**      | **N**      | **N**           |
| linux          | **Y**         | **Y**        | **Y**      | **N**      | **N**           |
| knife          | **N**         | **N**        | **N**      | **N**      | **N**           |
| windows        | **N**         | **N**        | **N**      | **N**      | **N**           |
