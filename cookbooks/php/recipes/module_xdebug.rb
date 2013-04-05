case node['platform']
when "centos", "redhat", "fedora"
  # unknown the state of this OS so leaving
when "debian", "ubuntu"
  package "php5-xdebug" do
    action :upgrade
  end
end