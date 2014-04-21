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

create_keypair_name = SampleHelper.get_required_option 'CREATE_KEYPAIR_NAME', "Enter name of keypair to create"
created_keypair = compute_service.key_pairs.create(:name => create_keypair_name)

upload_keypair_name = SampleHelper.get_required_option 'UPLOAD_KEYPAIR_NAME', "Enter name of keypair to upload"
uploaded_keypair = compute_service.key_pairs.create(:name => upload_keypair_name, :public_key => File.read(ENV['HOME'] + '/.ssh/id_rsa.pub'))