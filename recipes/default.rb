#
# Cookbook Name:: fah
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

install_dir = "/usr/local/fah"
fah_archive = "fah.tgz"
fah_archive_path = install_dir + "/" + fah_archive

fah_dist = if node.default[:kernel][:machine] == "x86_64"
             node.default[:fah][:build64]
           else
             node.default[:fah][:build32]
           end

directory install_dir do
  action :create
end

remote_file fah_archive_path do
  source fah_dist
  mode "0600"
end

execute "extract fah" do
  command "cd " + install_dir + " && tar xvzf " + fah_archive
end

template install_dir + "/client.cfg" do
  source "client.cfg.erb"
  variables(
    :username => node.default[:fah][:username],
    :team => node.default[:fah][:team],
    :passkey => node.default[:fah][:passkey])
end

execute "start fah" do
  command "nohup " + install_dir + "/fah6 &"
#  not_if "ps aux | grep -v grep | grep fah6"
end
