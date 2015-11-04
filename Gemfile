source 'https://rubygems.org'

group :rake do
  gem 'rake'
  gem 'tomlrb'
end

group :lint do
  gem 'foodcritic', '~> 5.0'
  gem 'rubocop', '~> 0.34'
end

group :unit do
  gem 'berkshelf',  '~> 4.0'
  gem 'chefspec',   '~> 4.4'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.4'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant', '~> 0.19'
  gem 'winrm-transport', '~> 1.0'
end

group :kitchen_cloud do
  gem 'kitchen-digitalocean'
  gem 'kitchen-ec2'
end

group :development do
  gem 'guard'
  gem 'guard-kitchen'
  gem 'guard-rspec', '~> 4.0'
  gem 'rb-fchange', '~> 0.0'
  gem 'rb-fsevent', '~> 0.9'
  gem 'rb-inotify', '~> 0.9'
  gem 'ruby_gntp', '~> 0.3'
end
