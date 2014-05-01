#!/usr/bin/env ruby

# This example demonstrates creating a file on the CDN network with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

# create Cloud Files service
service = Fog::Storage.new({
  :provider             => 'Rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => :ord #Use Chicago Region
  })

# prompt for directory name
directory_name = get_user_input "\nEnter name of directory to create"

# create directory with CDN service
directory = service.directories.create :key => directory_name, :public => true

# upload file
upload_file = File.join(File.dirname(__FILE__), "lorem.txt")
file = directory.files.create :key => 'sample.txt', :body => File.open(upload_file, "r")

puts "You should be able to view this file via CDN at #{file.public_url}"
puts "To delete the container and associated file please execute the delete_directory.rb script\n\n"

