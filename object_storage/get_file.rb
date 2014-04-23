#!/usr/bin/env ruby

# This example demonstrates retrieve an object
# 
# Services used:
#   - [Get Object Content and Metadata](http://docs.rackspace.com/files/api/v1/cf-devguide/content/GET_getobjectdata_v1__account___container___object__objectServicesOperations_d1e000.html)

require 'fog'
require 'fileutils'
require File.expand_path('../../sample_helper', __FILE__)

Excon.defaults[:ssl_verify_peer] = false

# create Cloud Files service
service = Fog::Storage.new({
  :provider             => 'Rackspace',
  :rackspace_username   => SampleHelper.rackspace_username,
  :rackspace_api_key    => SampleHelper.rackspace_api_key,
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  # :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

# prompt for directory name
remote_directory_name = SampleHelper.get_required_option 'REMOTE_DIRECTORY', 'Enter the name of the container you wish to download from'
remote_directory = service.directories.get remote_directory_name
raise 'The specified container does not exist.' if remote_directory.nil?

object_key = SampleHelper.get_required_option 'REMOTE_FILE', 'Enter the path within the container of the object you wish to download'
remote_file = remote_directory.files.get object_key

local_directory = SampleHelper.get_required_option 'LOCAL_DIRECTORY', 'Enter the local directory to store the download file'
local_file = File.join(local_directory, remote_file.key)
FileUtils.mkdir_p File.dirname(local_file)

# download file
File.open(local_file, 'w') do | f |
  remote_directory.files.get(remote_file.key) do | data, remaining, content_length |
    f.syswrite data
  end
end

puts "\nFile #{remote_file.key} was successfully downloaded to #{local_file}"