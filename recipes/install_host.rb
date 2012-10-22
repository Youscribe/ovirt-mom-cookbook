include_recipe "mom::install"

configuration_file = ::File.join( "/usr/share/doc/mom/examples/", "mom-#{node['mom']['rules'].join("+")}.conf" )

directory "/etc/mom" do
  owner "root"
  group "root"
  mode "0644"
  action :create
end

file "momd configuration" do
  path "/etc/mom/mom.conf"
  content IO.read(configuration_file)
  owner "root"
  group "root"
  mode "0644"
  action :create_if_missing
  only_if { ::File.exist?(configuration_file) }
  subscribes :create, resources("bash[install mom]")
  notifies :restart, "service[momd]"
end

node['mom']['rules'].each do |rule|
  file rule do
    path "/etc/mom/#{rule}.rules"
    content IO.read("/usr/share/doc/mom/examples/#{rule}.rules")
    owner "root"
    group "root"
    mode "0644"
    action :create_if_missing
    only_if { ::File.exist?("/usr/share/doc/mom/examples/#{rule}.rules") }
    subscribes :create, resources("bash[install mom]")
  end
end

template "upstart momd" do
  path "/etc/init/momd.conf"
  source "upstart.momd.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :rule => node['mom']['rules']
  )
  notifies :restart, "service[momd]"
end


service "momd" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
