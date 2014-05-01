#!/usr/bin/env ruby

# This example demonstrates uploading large files in segments

require 'rubygems' #required for Ruby 1.8.x
require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

# Size of segment. The Rackspace cloud currently requires files larger than 5GB to be segmented so we will choose 5GB -1 for a size
# http://docs.rackspace.com/files/api/v1/cf-devguide/content/Large_Object_Creation-d1e2019.html
SEGMENT_LIMIT = 5368709119.0

# Size of buffer to use for transfers. Use Excon's default chunk size and if that's not avaliable we will default to 1 MB
BUFFER_SIZE = Excon.defaults[:chunk_size] || 1024 * 1024

# create Cloud Files service
service = Fog::Storage.new({
  :provider             => 'Rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region     => :ord
  })


# retrieve directories with files
directories = service.directories

# prompt for directory
directory = select_directory(directories)

# prompt for file name
file_name = get_user_input "Enter full path of file to upload"
segment_name = File.basename(file_name)

File.open(file_name) do |f|
  num_segments = (f.stat.size / SEGMENT_LIMIT).round + 1
  puts "\nThis upload of '#{file_name}' will require #{num_segments} segment(s) and 1 manifest file\n"


  segment = 0
   until f.eof?
     segment += 1
     offset = 0

     # upload segment to cloud files
     segment_suffix = segment.to_s.rjust(10, '0')
     print "\n\tUploading segment #{segment_suffix} "
     service.put_object(directory.key, "#{segment_name}/#{segment_suffix}", nil) do
       if offset <= SEGMENT_LIMIT - BUFFER_SIZE
         print "."
         buf = f.read(BUFFER_SIZE).to_s
         offset += buf.size
         buf
       else
         ''
       end
     end
   end
 end

puts "\n\n\tWriting manifest #{segment_name}\n\n"
service.put_object_manifest(directory.key, segment_name, 'X-Object-Manifest' => "#{directory.key}/#{segment_name}/" )

puts <<-NOTE
You should now be able to download #{segment_name} from the cloud control panel or using the following code:

    directory = service.directories.get('#{directory.key}')
    File.open('downloaded_#{segment_name}', 'w') do | f |
      directory.files.get('#{segment_name}') do | data, remaining, content_length |
        print "."
        f.write data
      end
    end

NOTE
