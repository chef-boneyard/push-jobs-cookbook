require 'chefspec'
require 'berkshelf'

Berkshelf::Berksfile.from_file('Berksfile').install(path: 'vendor/cookbooks/')

# Without this line, berks will infinitely nest vendor/cookbooks/push-jobs on each rspec run
# https://github.com/RiotGames/berkshelf/issues/828
require 'fileutils'
RSpec.configure do |c|
  c.after(:suite) do
    FileUtils.rm_rf('vendor/')
  end
end