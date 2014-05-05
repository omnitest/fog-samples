#!/usr/bin/env ruby

# This example demonstrates retrieve an object
# 
# Services used:
#   - [Get Object Content and Metadata](http://docs.rackspace.com/files/api/v1/cf-devguide/content/GET_getobjectdata_v1__account___container___object__objectServicesOperations_d1e000.html)

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
directory = SampleHelper.select_container service.directories
raise 'The specified container does not exist.' if directory.nil?

puts "\nPreparing to delete #{directory.key}"

# delete files if necessary
directory.files.each do |f|
  puts "\tDeleting file #{f.key}"
  retriable do
    f.destroy
  end
end

# delete directory
puts "\tDeleting container #{directory.key}"
retriable do
  directory.destroy
end

puts "\tDone\n\n"