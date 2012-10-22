include_recipe "python"

mom_path = ::File.join( node['chef_client']['cache_path'], "mom" )

git "mom sources" do
  destination mom_path
  repository node['mom']['repository']
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
