#!/usr/bin/env ruby

# This example demonstrates posting a message to a queue with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

# create Queue Service
service = Fog::Rackspace::Queues.new({
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => :ord #Use Chicago Region
})

# retrieve list of queues
queues = service.queues

# prompt for queue to delete
queue = select_queue(queues)

# prompt for queue message
message = get_user_input "Enter Queue Message"

# time to live TTL = 1 hour
ttl = 3600

# post message to queue
queue.messages.create :body => message, :ttl => ttl

puts "The message has been successfully posted"
