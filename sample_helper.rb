require 'fog'

Fog.mock! if ENV['FOG_MOCK'] # Not everything works

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

    def select_option(key, list, prompt = "Please select from the values below")
      value = get_option(key) do
        puts "#{prompt}:"
        list.each_with_index do |list_item, index|
          puts "#{index}. #{list_item.name}"
        end
        print "Selection: "
        selection = gets.chomp.to_i
        value = list[selection].name
      end
    end

    def select_flavor(flavors, server)
      flavor_name = SampleHelper.select_option('SERVER_SIZE', flavors.all, 'Select server flavor')
      find_matching flavors, flavor_name
    end

    def select_server(servers)
      server_name = SampleHelper.select_option('SERVER_NAME', servers.all, 'Select a server')
      find_matching servers, server_name
    end

    def select_attachment(attachments)
      SampleHelper.get_option('ATTACHMENT_NAME') do
        abort "\nThis server does not contain any volumes in the Chicago region. Try running server_attachments.rb\n\n" if attachments.empty?

        puts "\nSelect Volume To Detach:\n\n"
        attachments.each_with_index do |attachment, i|
          puts "\t #{i}. #{attachment.device}"
        end

        delete_str = get_user_input "\nEnter Volume Number"
        attachments[delete_str.to_i]
      end
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
        "#{auth_url}/v2.0"
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
    def find_matching(collection, name)
      # Handle identity - so you can pass object, object_name
      return name if collection.include? name 
      collection.each do |single|
        return single if single.id == name
        return single if single.name == name
        return single if name.is_a?(Regexp) && name =~ single.name
      end

      nil
    end

  end
end