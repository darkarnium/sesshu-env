#
# Cookbook Name:: sesshu-env
# Recipe:: app
#

# Ensure a user exists.
user node['sesshu']['user'] do
  manage_home false
  shell '/bin/bash'
end

# Fetch and install the sesshu from develop.
git node['sesshu']['home'] do
  repository node['sesshu']['git']['path']
  reference node['sesshu']['git']['branch']
  action :sync
end

# Ensure Python 2 is installed.
python_runtime '2'

# Install required Python modules.
pip_requirements "#{node['sesshu']['home']}/requirements.txt"

# Write out the correct configuration document for sesshu.
deploy_configuration "#{node['sesshu']['home']}/conf/sesshu.dist.yaml" do
  destination "#{node['sesshu']['home']}/conf/sesshu.yaml"
  additions node['sesshu']['conf']
end

# Provides a reload facility for systemd - which is only invoked via notify
# on unit file installation, change, etc.
execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
  action :nothing
end

# Install the systemd unit file.
template '/etc/systemd/system/sesshu.service' do
  mode 0755
  owner 'root'
  group 'root'
  source 'sesshu.service.erb'
  variables(
    script: "#{node['sesshu']['home']}/sesshu.py"
  )
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
end

# Ensure the service runs on boot, and start it.
service 'sesshu' do
  supports status: true, restart: true
  action [:enable, :start]
end
