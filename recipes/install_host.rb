#
# Cookbook Name:: ovirt-mom
# Recipe:: install_host
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 2012, Societe Publica.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "ovirt-mom::install"

configuration_file = ::File.join( "/usr/share/doc/mom/examples/", "mom-#{node['ovirt']['mom']['rules'].join("+")}.conf" )

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

node['ovirt']['mom']['rules'].each do |rule|
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
    :rule => node['ovirt']['mom']['rules']
  )
  notifies :restart, "service[momd]"
end


service "momd" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
