#!/usr/bin/env ruby

# This example demonstrates listing messages in a queue with the Rackpace Open Cloud

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

queue.messages.echo = get_user_boolean "Do you want to include your own messages? [y/N]"

queue.messages.include_claimed = get_user_boolean "Do you want to include claimed messages? [y/N]"

puts "\n\nThe following messages are in the '#{queue.name}' queue:\n\n"

queue.messages.each do |message|
  puts message.inspect
end
