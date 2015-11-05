require 'serverspec'
require 'pathname'

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
  set :path, '/sbin:/usr/local/sbin:/usr/bin:/bin'
else
  set :backend, :cmd
  set :os, family: 'windows'
end

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |file| require_relative(file) }

def windows?
  os[:family] == 'windows'
end

def chef_file_cache
  if windows?
    'C:/Users/vagrant/AppData/Local/Temp/kitchen/cache'
  else
    '/tmp/kitchen/cache'
  end
end
