#!/usr/bin/env ruby
require 'mixlib/shellout'

MINUTES = 60 # in seconds

STANDARD_ENV_VARS = {
  'RAX_USERNAME' => ENV['RAX_USERNAME'],
  'RAX_API_KEY'  => ENV['RAX_API_KEY'],
  # 'RAX_AUTH_URL' => PACTO_URL,
  'RAX_REGION'   => 'ORD' # Could select randomly
  # HOME is used to find SSH key - may need to be fixed for Windows
}

# SampleHelper.get_option('ATTACHMENT_NAME'
# SampleHelper.get_option('UPLOAD_FILE') || 'fixtures/lorem.txt'
# SampleHelper.get_required_option 'CONFIRM_DELETE', 'Would You Like To Destroy Volume #{volume.display_name} (y/n)'
# SampleHelper.get_required_option 'CREATE_KEYPAIR_NAME', 'Enter name of keypair to create'
# SampleHelper.get_required_option 'LOCAL_DIRECTORY', 'Enter the local directory to store the download file'
# SampleHelper.get_required_option 'REMOTE_DIRECTORY', 'Enter name of directory to create'
# SampleHelper.get_required_option 'REMOTE_DIRECTORY', 'Enter name of the target container'
# SampleHelper.get_required_option 'REMOTE_DIRECTORY', 'Enter the name of the container to delete'
# SampleHelper.get_required_option 'REMOTE_DIRECTORY', 'Enter the name of the container you wish to download from'
# SampleHelper.get_required_option 'REMOTE_FILE', 'Enter the path within the container of the object you wish to download'
# SampleHelper.get_required_option 'SERVER_NAME', '\nEnter Server Name'
# SampleHelper.get_required_option 'UPLOAD_DIRECTORY', 'Location of the directory to upload'
# SampleHelper.get_required_option 'UPLOAD_KEYPAIR_NAME', 'Enter name of keypair to upload'
# SampleHelper.get_required_option 'VOLUME_NAME', 'Enter Volume Name'

# ENV['CONTAINER_NAME']
# ENV['FOG_MOCK']
# ENV['HOME']
# ENV['RAX_API_KEY']
# ENV['RAX_AUTH_URL']
# ENV['RAX_REGION']
# ENV['RAX_USERNAME']
# ENV['SERVER1_FLAVOR']
# ENV['SERVER1_IMAGE']
# ENV['TEST_DIRECTORY']
# ENV['TEST_DIRECTORY'], ENV['TEST_FILE']
# ENV['TEST_FILE']
# ENV[key]



def findScript(test_name)
  file = Dir.glob("**/*#{test_name}.*", File::FNM_CASEFOLD).first ||
    Dir.glob("**/*#{test_name.gsub(' ', '')}.*", File::FNM_CASEFOLD).first
  raise "Could not find script for #{test_name}" if file.nil? or !File.readable?(file)
  file
end

def runSuite(suite_name, tests, env)
  puts "Running suite: #{suite_name}"
  test_env = STANDARD_ENV_VARS.merge(env)
  tests.each do |test|
    puts "  Running test: #{test}"
    script = findScript test
    cmd = Mixlib::ShellOut.new("bundle exec ruby #{script}", :env => test_env, :live_stream => $stdout, :timeout => 20 * MINUTES)
    cmd.run_command # etc.
    cmd.error!
  end
end

# delete_server is missing
# resizing server with an attached volume is an interesting scenario
runSuite("Compute", %w{create_keypair create_server attach_volume resize_server detach_volume}, {
  'CONFIRM_DELETE' => 'y',
  'CREATE_KEYPAIR_NAME' => 'my_test_keypair',
  'UPLOAD_KEYPAIR_NAME' => 'my_uploaded_keypair',
  'SERVER_NAME' => 'my_test_server',
  'VOLUME_NAME' => 'my_test_volume'
})

# temporarily remove delete_container
runSuite("Storage", %w{create_container upload_file upload_directory change_metadata get_file}, {
  'REMOTE_DIRECTORY' => 'automated_test_dir',
  'LOCAL_DIRECTORY'  => 'tmp/storage',
  'REMOTE_FILE'      => 'sample.txt',
  'UPLOAD_DIRECTORY' => 'fixtures/sample_site'
})
