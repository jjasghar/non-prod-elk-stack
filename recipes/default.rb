# coding: utf-8
#
# Cookbook Name:: non-prod-elk-stack
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'apt'

%w{default-jdk}.each do |pkg|
  package pkg do
    action [:install]
  end
end

remote_file "/tmp/elasticsearch-1.5.0.deb" do
  source "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.0.deb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "install elasticsearch" do
  command "dpkg -i /tmp/elasticsearch-1.5.0.deb"
end

service "elasticsearch" do
  supports :status => true, :restart => true, :truereload => true
  action [ :enable, :start ]
end

directory "/etc/logstash/" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

directory "/etc/logstash/conf.d/" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

template "/etc/logstash/conf.d/logstash.conf" do
  source "logstash.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

remote_file "/tmp/logstash_1.4.2-1-2c0f5a1_all.deb" do
  source "https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.2-1-2c0f5a1_all.deb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "install logstash" do
  command "dpkg -i /tmp/logstash_1.4.2-1-2c0f5a1_all.deb"
end

remote_file "/tmp/logstash-contrib_1.4.2-1-efd53ef_all.deb" do
  source "https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash-contrib_1.4.2-1-efd53ef_all.deb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "install logstash contrib" do
  command "dpkg -i /tmp/logstash-contrib_1.4.2-1-efd53ef_all.deb"
end

service "logstash" do
  supports :status => true, :restart => true, :truereload => true
  action [ :start ]
end

remote_file "/tmp/kibana-4.0.1-linux-x64.tar.gz" do
  source "https://download.elasticsearch.org/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

directory "/opt/kibana" do
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "extract kibana on where it needs to be" do
  command "tar -xvf /tmp/kibana-4.0.1-linux-x64.tar.gz -C /opt/kibana --strip-components=1"
end

remote_file "/etc/init.d/kibana4" do
  source "https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4"
  owner "root"
  group "root"
  mode "0755"
end

execute "start kibana" do
  command "/etc/init.d/kibana4 start"
end
