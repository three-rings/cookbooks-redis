#
# Cookbook Name:: Redis
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "tcl"

bin = "/usr/local/bin/redis-server"
version  = node[:redis][:version]
src_file = "http://redis.googlecode.com/files/redis-#{version}.tar.gz"
installed_version = `#{bin} -v 2>&1`.chomp.split(/\s/)[3]
log "installed version: #{installed_version}"
do_install = ( version != installed_version )


cookbook_file "/tmp/#{src_file}" do
  source src_file 
  only_if { do_install }
end

bash "install_redis" do
  cwd "/tmp"
  code <<-EOH
  tar zxvf #{src_file} && cd redis-#{version} && make && make install && cp utils/redis_init_script /etc/init.d/redis
  EOH
  only_if { do_install }
end

file "/tmp/#{src_file}" do
  action :delete
end

