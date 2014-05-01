#!/usr/bin/env ruby

# This example demonstrates adding a webhook to an auto scaling group with the Rackpace Open Cloud

require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

def select_group(groups)
  abort "\nThere are no groups in the Chicago region. Try running create_scaling_group.rb\n\n" if groups.empty?

  puts "\nSelect Group With Policy:\n\n"
  groups.each_with_index do |group, i|
    config = group.group_config
    puts "\t #{i}. #{config.name}"
  end

  select_str = get_user_input "\nEnter Group Number"
  groups[select_str.to_i]
end

def select_policy(policies)
  abort "\nThere are no policies for this scaling group. Try running add_policy.rb\n\n" if policies.empty?

  puts "\nSelect Policy Triggered By Webhook:\n\n"
  policies.each_with_index do |policy, i|
    puts "\t #{i}. #{policy.name}"
  end

  select_str = get_user_input "\nEnter Policy Number"
  policies[select_str.to_i]
end

# create auto scaling service
auto_scale_service = Fog::Rackspace::AutoScale.new({
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => :ord # Use Chicago Region
})

# retrieve list of scaling groups
groups = auto_scale_service.groups

# prompt for group
group = select_group(groups)

# retrieve list of policies for group
policies = group.policies

# prompt for policy to delete
policy = select_policy(policies)

# prompt for webhook name
webhook_name = get_user_input "Enter name for webhook"

# create webhook
webhook = policy.webhooks.create :name => webhook_name

puts "\nWebhook #{webhook.name} was successfully added - #{webhook.execution_url}"
