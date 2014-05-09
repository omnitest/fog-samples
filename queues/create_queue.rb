#!/usr/bin/env ruby

# This example demonstrates creating a queue with the Rackpace Open Cloud

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

#prompt for queue name
queue_name = SampleHelper.get_required_option 'QUEUE_NAME', "Enter name for queue"

begin
  # create queue
  queue = service.queues.create :name => queue_name
  puts "Queue #{queue_name} was successfully created"

  puts "To delete the queue please execute the delete_queue.rb script\n\n"
rescue Fog::Rackspace::Queues::ServiceError => e
  if e.status_code == 204
    puts "Queue #{queue_name} already exists"
  end
end