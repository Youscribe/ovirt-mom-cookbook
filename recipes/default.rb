#
# Cookbook Name:: mom
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if node['mom']['role']
  include_recipe "mom::install_#{node['mom']['role']}"
end
