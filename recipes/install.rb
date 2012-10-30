#
# Cookbook Name:: ovirt-mom
# Recipe:: install
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

include_recipe "python"

mom_path = ::File.join( Chef::Config[:file_cache_path], "mom" )

git "mom sources" do
  destination mom_path
  repository node['ovirt']['mom']['repository']
  reference "master"
  action :sync
  notifies :run, "bash[install mom]", :immediately
end

bash "install mom" do
  user "root"
  cwd mom_path
  code <<-EOH
    python setup.py install
  EOH
  action :nothing
end
