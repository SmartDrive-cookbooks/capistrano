#
# Cookbook Name:: capistrano
# Recipe:: default
#
# Copyright 2014, Yuki Osawa
#
# All rights reserved - Do Not Redistribute
#

# rbenv install
include_recipe "ruby_build"
include_recipe "rbenv::system"

rbv = node["chef-capistrano"]["ruby"]["version"]

rbenv_ruby rbv
rbenv_global rbv

# capistrano install
rbenv_gem "capistrano" do
	rbenv_version rbv
	version node["chef-capistrano"]["version"] if node["chef-capistrano"]["pinning_version"]
	action :install
	options node["chef-capistrano"]["options"] if node["chef-capistrano"]["options"]
end

# capistrano plugins install
node["chef-capistrano"]["plugins"].each do |plugin|
	if plugin.is_a?(Hash)
		rbenv_gem plugin["name"] do
			%w{action version options source}.each do |attr|
				send(attr, plugin[attr]) if plugin[attr]
			end
		end
	elsif plugin.is_a?(String)
		rbenv_gem plugin
	end
end
