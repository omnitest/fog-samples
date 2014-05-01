#!/usr/bin/env ruby

# This example demonstrates creating a file on the CDN network with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

def print_metadata(object)
  object.metadata.each_pair do |key, value|
    puts "\t#{key}: #{value}"
  end
  puts "\n"
end

# create Cloud Files service
service = Fog::Storage.new({
  :provider             => 'Rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => :ord #Use Chicago Region
  })


# create directory
puts "Creating directory 'metadata-tester'"
directory = service.directories.create :key => "metadata-tester"

# initial metadata
puts "Initial Container Metadata\n"
print_metadata directory

# adding metadata
puts "Adding Container Metadata"
directory.metadata["environment"] = "demo"
directory.save
print_metadata directory

# update metadata
puts "Updating Container Metadata"
directory.metadata["environment"] = "test"
directory.save
print_metadata directory

# upload file
puts "Uploading file"
upload_file = File.join(File.dirname(__FILE__), "lorem.txt")
file = directory.files.create :key => 'sample.txt', :body => File.open(upload_file, "r")

# initial metadata
puts "Initial File Metadata\n"
print_metadata file

# adding metadata
puts "Adding File Metadata"
file.metadata["preview"] = "true"
file.save
print_metadata file

# update metadata
puts "Updating File Metadata"
file.metadata["preview"] = "false"
file.save
print_metadata file

puts "To delete the directory and file please execute the delete_directory.rb script\n\n"





