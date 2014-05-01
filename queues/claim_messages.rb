#!/usr/bin/env ruby

# This example demonstrates claiming messages with the Rackpace Open Cloud

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

# prompt for queue
queue = select_queue(queues)

# prompt for number of messages to claim
num_claims = get_user_input "Enter Number of Messages to Claim"

# Claim messages
claim = queue.claims.create :ttl => 300, :grace => 100, :limit => num_claims

puts "The following messages have been claimed for the next 5 minutes [#{claim.id}]"

claim.messages.each do |message|
  puts "\t[#{message.id}] #{message.body[0..50]}"
end
