# スワップ領域作成
# 参考:http://qiita.com/naoya@github/items/2059e3755962e907315e
bash 'create swapfile' do
  user 'root'
  code <<-EOC
    dd if=/dev/zero of=/swap.img bs=1M count=1024 &&
    chmod 600 /swap.img
    mkswap /swap.img
  EOC
  only_if "test ! -f /swap.img -a `cat /proc/swaps | wc -l` -eq 1"
end

mount '/dev/null' do # swap file entry for fstab
  action :enable # cannot mount; only add to fstab
  device '/swap.img'
  fstype 'swap'
end

bash 'activate swap' do
  code 'swapon -ae'
  only_if "test `cat /proc/swaps | wc -l` -eq 1"
end

# iptables無効
service "iptables" do
	action [:stop, :disable]
end

yum_package "yum-fastestmirror" do
  action :install
end

# yumの更新
execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

# EPEL repository
bash 'add_epel' do
  user 'root'
  code <<-EOC
    rpm -ivh http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
  EOC
  creates "/etc/yum.repos.d/epel.repo"
end

# MySQL repository
bash 'add_mysql_repo' do
  user 'root'
  code <<-EOC
    rpm -ivh http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
  EOC
  creates "/etc/yum.repos.d/mysql-community.repo"
end

# yum関係
%w{glibc glibc-devel gcc gcc-c++ make kernel-devel wget readline-devel ncurses-devel gdbm-devel openssl-devel libxslt-devel sqlite-devel ruby-devel libmcrypt libmcrypt-devel vim }.each do |p|
	package p do
		action :install
	end
end

# 設定の追記
bash 'update resolv.conf' do
  user 'root'
  code <<-EOC
    echo "options single-request-reopen" >> /etc/resolv.conf
  EOC
end

# remi repository導入
remote_file "/tmp/#{node['nginx']['file_name']}" do
  source "#{node['nginx']['remote_uri']}"
  not_if { ::File.exists?("/tmp/#{node['nginx']['file_name']}") }
end

package node['nginx']['file_name'] do
  action :install
  provider Chef::Provider::Package::Rpm
  source "/tmp/#{node['nginx']['file_name']}"
end

