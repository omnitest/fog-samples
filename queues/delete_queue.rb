#!/usr/bin/env ruby

# This example demonstrates deleting a queue with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

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

# delete queue
queue.destroy

puts "\nQueue #{queue.name} has been destroyed\n"
