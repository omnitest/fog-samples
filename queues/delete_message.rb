#!/usr/bin/env ruby

# This example demonstrates deleting a message with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'
require File.expand_path('../../sample_helper', __FILE__)


# Use username defined in ~/.fog file, if absent prompt for username.
# For more details on ~/.fog refer to http://fog.io/about/getting_started.html
def rackspace_username
  Fog.credentials[:rackspace_username] || get_user_input("Enter Rackspace Username")
end

# Use api key defined in ~/.fog file, if absent prompt for api key
# For more details on ~/.fog refer to http://fog.io/about/getting_started.html
def rackspace_api_key
  Fog.credentials[:rackspace_api_key] || get_user_input("Enter Rackspace API key")
end

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

#retrieve list of messages
messages = queue.messages

# prompt for message
message = select_message(messages)

# delete message
message.destroy

puts "\nMessage #{message.id} has been destroyed\n"
