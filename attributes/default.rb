
if node['virtualization']['system'] == "kvm"
  case node['virtualization']['role']
  when "guest"
    default['mom']['role'] = "guest"
  when "host"
    default['mom']['role'] = "host"
  end
else
   default['mom']['role'] = false
end

## wait https://bugzilla.redhat.com/show_bug.cgi?id=869060
#node['mom']['repository'] = "git://gerrit.ovirt.org/mom"
default['mom']['repository'] = "git://github.com/Youscribe/mom.git"

default['mom']['rules'] = [ "balloon", "ksm" ]
