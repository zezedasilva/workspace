#
# Cookbook Name:: basics
# Recipe:: default
#
# Andreas Hoffmann <furizaa@gmail.com>
#

packages = [
	'lsof',
	'iptables',
	'whois',
	'curl',
	'ack',
	'libsybdb5',
	'wget',
	'vim',
	'rsync',
	'jnettop',
	'nmap',
	'traceroute',
	# 'ethtool',
	'iproute',
	'iputils-ping',
	'netcat-openbsd',
	'tcpdump',
	'elinks',
	'mc',
	'debconf',
	'freetds-common',
	'htop',
	'gawk'
]

case node[:platform]
when "debian", "ubuntu"
	packages.each do |pkg|
		package pkg do
			action :install
		end
	end
end