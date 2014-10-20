require 'fog'

Fog.mock! if ENV['FOG_MOCK'] # Not everything works

def retriable
  tries = 3
  begin
    yield
  rescue Excon::Errors::SocketError, Excon::Errors::Timeout, Fog::Rackspace::Errors::ServiceError => e
    $stderr.puts e.inspect
    tries -= 1
    if tries > 0
      sleep 3
      retry
    else
      raise
    end
  end
end

class SampleHelper
  class << self

    def get_user_input(prompt)
      print "#{prompt}: "
      gets.chomp
    end

    def get_option(key, &default_callback)
      value = ENV[key]
      if value.nil? && default_callback
        value = default_callback.call
        # set_option key, value
      end
      value
    end

    def set_option(key, value)
      ENV[key] = value
    end

    def get_required_option(key, prompt = "Enter a value for #{key}")
      get_option(key) do
        get_user_input prompt
      end
    end

    def select_option(key, list, prompt = "Please select from the values below", display_field = :name, &blk)
      value = get_option(key) do
        puts "#{prompt}:"
        list.each_with_index do |list_item, index|
          puts "#{index}. #{list_item.send display_field}"
        end
        print "Selection: "
        selection = gets.chomp.to_i
        value = list[selection]
      end
    end

    def select_container(containers)
      container = SampleHelper.select_option('REMOTE_DIRECTORY', containers.all, 'Select a container', :key)
      find_matching containers, container, :key
    end

    def select_flavor(flavors)
      flavor = SampleHelper.select_option('SERVER_SIZE', flavors.all, 'Select server flavor')
      find_matching flavors, flavor
    end

    def select_server(servers)
      server = SampleHelper.select_option('SERVER_NAME', servers.all, 'Select a server')
      find_matching servers, server
    end

    def select_attachment(attachments)
      attachment = SampleHelper.select_option('ATTACHMENT_NAME', attachments.all, 'Select an attachment', :device)
      find_matching attachments, attachment, :device
    end

    def select_queue(queues)
      queue = SampleHelper.select_option('QUEUE_NAME', queues.all, 'Select a queue')
      find_matching queues, queue
    end

    def select_load_balancer(load_balancers)
      load_balancer = SampleHelper.select_option('LOAD_BALANCER_NAME', load_balancers.all, 'Select a load balancer')
      find_matching load_balancers, load_balancer
    end

    def rackspace_username
      get_required_option('RAX_USERNAME', 'Enter Rackspace Username')
    end

    def rackspace_api_key
      get_required_option('RAX_API_KEY', 'Enter Rackspace API key')
    end

    def rackspace_region
      get_required_option('RAX_REGION', 'Enter Rackspace Region').to_sym
    end

    def authentication_endpoint
      auth_url = get_option('OS_AUTH_URL')
      if auth_url
        "#{auth_url}"
      else
        'https://identity.api.rackspacecloud.com/v2.0'
      end
    end

    private

    # Taken from vagrant-rackspace, added identity check
    #
    # This method finds a matching _thing_ in a collection of
    # _things_. This works matching if the `name` is equal to
    # an object, ID or NAME in the collection. Or, if `name`
    # is a regexp, a partial match is chosen as well.
    def find_matching(collection, name, primary_key = :id)
      # Handle identity - so you can pass object, object_name
      return name if collection.include? name
      collection.each do |single|
        # It's usually id, but are other possibilities like device
        if single.respond_to? primary_key
          return single if single.send(primary_key) == name
        end
        if single.respond_to? :name
          return single if single.name == name
          return single if name.is_a?(Regexp) && name =~ single.name
        end
      end

      nil
    end

  end
end
