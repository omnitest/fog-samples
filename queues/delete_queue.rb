#!/usr/bin/env ruby

# This example demonstrates posting a message to a queue with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

# create Queue Service
service = Fog::Rackspace::Queues.new({
  :rackspace_username   => SampleHelper.rackspace_username,
  :rackspace_api_key    => SampleHelper.rackspace_api_key,
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

# retrieve list of queues
queues = service.queues

# prompt for queue to send message
queue = SampleHelper.select_queue(queues)

# delete queue
queue.destroy

puts "\nQueue #{queue.name} has been destroyed\n"