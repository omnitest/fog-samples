#!/usr/bin/env ruby

# This example demonstrates adding a poicy to an auto scaling group with the Rackpace Open Cloud

require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

def select_group(groups)
  abort "\nThere are not any scaling groups in the Chicago region. Try running create_scaling_group.rb\n\n" if groups.empty?

  puts "\nSelect Group For New Policy:\n\n"
  groups.each_with_index do |group, i|
    config = group.group_config
    puts "\t #{i}. #{config.name}"
  end

  select_str = get_user_input "\nEnter Group Number"
  groups[select_str.to_i]
end


# create auto scaling service
auto_scale_service = Fog::Rackspace::AutoScale.new({
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => :ord # Use Chicago Region
})


# retrieve list of scaling groups
groups = auto_scale_service.groups

# prompt group
group = select_group(groups)

# prompt for policy name
policy_name = get_user_input "Enter name for policy"

# prompt for cool down period for policy
cooldown = get_user_input_as_int "Enter cool down period in seconds"

# prompt for change increment
change = get_user_input_as_int "Enter change increment"

group.policies.create :name => policy_name, :cooldown => cooldown, :type => 'webhook', :change => change

puts "\nPolicy #{policy_name} was successfully added to group"
