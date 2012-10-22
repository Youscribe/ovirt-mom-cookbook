include_recipe "mom::install"

template "upstart mom-guestd" do
  path "/etc/init/mom-guestd.conf"
  source "upstart.mom-guestd.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[mom-guestd]"
end

service "mom-guestd" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
  
