#!/usr/bin/env ruby

# This example demonstrates how to create or upload a keypair for use with Cloud Servers.
# 
# Services used:
#   - [Create Server Key Pair](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/CreateKeyPair.html)
#   - [Upload Server Key Pair](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/UploadKeyPair.html)

require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

#create Next Generation Cloud Server service
compute_service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => SampleHelper.rackspace_username,
  :rackspace_api_key    => SampleHelper.rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

created_keypair_name = SampleHelper.get_required_option 'CREATE_KEYPAIR_NAME', "Enter name of the created keypair to delete"
compute_service.key_pairs.destroy created_keypair_name

uploaded_keypair_name = SampleHelper.get_required_option 'UPLOAD_KEYPAIR_NAME', "Enter name of the uploaded keypair to delete"
compute_service.key_pairs.destroy uploaded_keypair_name