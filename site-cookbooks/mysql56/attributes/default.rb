default['mysql']['file_name']  = "mysql-community-release-el6-5.noarch.rpm"
default['mysql']['remote_uri'] = "http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm"

default['mysql']['packages'] = %w[
  mysql-community-client
  mysql-community-devel
  mysql-community-server
]