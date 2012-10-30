
if node['virtualization']['system'] == "kvm"
  case node['virtualization']['role']
  when "guest"
    default['ovirt']['mom']['role'] = "guest"
  when "host"
    default['ovirt']['mom']['role'] = "host"
  end
else
   default['ovirt']['mom']['role'] = false
end

## wait https://bugzilla.redhat.com/show_bug.cgi?id=869060
#node['mom']['repository'] = "git://gerrit.ovirt.org/mom"
default['ovirt']['mom']['repository'] = "git://github.com/Youscribe/mom.git"

default['ovirt']['mom']['rules'] = [ "balloon", "ksm" ]
