push_jobs_package 'install push jobs 2.4.1' do
  version '2.4.1'
  channel :stable
end

push_jobs_package 'install push jobs current stable' do
  action :upgrade
end
