require "#{File.dirname(File.dirname(File.dirname(__FILE__)))}/libraries/helpers"

describe 'PushJobsHelper' do

  it 'package_file method should return a  valid package filename' do
    package_url = 'http://foo.bar.com/opscode-push-jobs-client_amd64.deb?key=value'
    expect(PushJobsHelper.package_file(package_url)).to match 'opscode-push-jobs-client_amd64.deb'
  end

end
