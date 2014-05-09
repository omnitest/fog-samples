#!/usr/bin/env ruby

# This example demonstrates how to upload a folder
# 
# Services used:
#   - [Create or Update Object](http://docs.rackspace.com/files/api/v1/cf-devguide/content/PUT_createobject_v1__account___container___object__objectServicesOperations_d1e000.html)

require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

# create Cloud Files service
service = Fog::Storage.new({
  :provider             => 'Rackspace',
  :rackspace_username   => SampleHelper.rackspace_username,
  :rackspace_api_key    => SampleHelper.rackspace_api_key,
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

# prompt for directory name
directory_name = SampleHelper.get_required_option 'REMOTE_DIRECTORY', 'Enter name of the target container'
directory = service.directories.get directory_name
raise 'The specified container does not exist.' if directory.nil?

local_dir = Pathname.new(SampleHelper.get_required_option 'UPLOAD_DIRECTORY', 'Location of the directory to upload')

# Uploads files sequentially
Dir.glob("#{local_dir}/**/*").each do |full_path|
  path = Pathname.new(full_path).relative_path_from(local_dir)
  puts "Uploading #{path}"
  retriable do
    directory.files.create(:key => path.to_s, :body => File.open(full_path)) unless File.directory?(full_path)
  end
end

puts "You should be able to view this container via CDN at #{directory.public_url}"
puts "To delete the container and associated file please execute the delete_container.rb script\n\n"