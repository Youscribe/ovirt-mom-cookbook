#
# Cookbook Name:: ovirt-mom
# Recipe:: install_guest
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
  
