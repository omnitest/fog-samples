#!/usr/bin/env ruby

# This example demonstrates how to manage volumes on an existing server instance.
# 
# Services used:
#   - [Delete Volume Attachment](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Delete_Volume_Attachment.html)

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

cbs_service = Fog::Rackspace::BlockStorage.new({
  :rackspace_username => SampleHelper.rackspace_username,
  :rackspace_api_key  => SampleHelper.rackspace_api_key,
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

# retrieve list of servers
servers = compute_service.servers

# prompt user for server
server = SampleHelper.select_server(servers)

# get attached volumes --also know as attachments
attachments = server.attachments

# prompt user for volume to detach
attachment = SampleHelper.select_attachment(attachments)

raise "No attachment to delete" if attachment.nil?

volume = cbs_service.volumes.get attachment.volume_id
puts "Detaching Volume #{volume.display_name} From Server #{server.name}"
attachment.detach

puts "\n"
delete_confirm = SampleHelper.get_required_option 'CONFIRM_DELETE', "Would You Like To Destroy Volume #{volume.display_name} (y/n)"
if delete_confirm.downcase ==  'y'
  # wait for server to finish detaching before attempting to delete
  volume.wait_for(600)  do
    print "."
    STDOUT.flush
    puts "State: #{volume.state}"
    puts "Attachments: #{attachments.size}"
    ready?
  end

  volume.destroy

  puts "\n\nThe Volume Has been Destroyed"
end