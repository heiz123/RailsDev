# 競合するので削除する
package "mysql-libs" do
  action :remove
end

remote_file "/tmp/#{node['mysql']['file_name']}" do
  source "#{node['mysql']['remote_uri']}"
end

package "mysql-community-release" do
  action :install
  provider Chef::Provider::Package::Rpm
  source "/tmp/#{node['mysql']['file_name']}"
end

node['mysql']['packages'].each do |package|
  package package do
    action :install
  end
end

service "mysqld" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end


# my.cnf
template "my.cnf" do
	path "/usr/my.cnf"
	source "my.cnf.erb"
	mode 0644
	notifies :restart, 'service[mysqld]'
end

# 初期パスワード設定
# 参考:http://blog.youyo.info/blog/2013/07/11/chef-mysql56/
script "Secure_Install" do
  interpreter 'bash'
  user "root"
  not_if "mysql -u root -p#{node[:mysql][:password]} -e 'show databases'"
  code <<-EOL
    export Initial_PW=`head -n 1 /root/.mysql_secret |awk '{print $(NF - 0)}'`
    mysql -u root -p${Initial_PW} --connect-expired-password -e "SET PASSWORD FOR root@localhost=PASSWORD('#{node[:mysql][:password]}');"
    mysql -u root -p#{node[:mysql][:password]} -e "SET PASSWORD FOR root@'127.0.0.1'=PASSWORD('#{node[:mysql][:password]}');"
    mysql -u root -p#{node[:mysql][:password]} -e "FLUSH PRIVILEGES;"
  EOL
end