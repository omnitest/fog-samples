#!/usr/bin/env ruby
require 'rspec'
require 'mixlib/shellout'

MINUTES = 60 # in seconds

STANDARD_ENV_VARS = {
  'RAX_USERNAME' => ENV['RAX_USERNAME'],
  'RAX_API_KEY'  => ENV['RAX_API_KEY'],
  # 'RAX_AUTH_URL' => PACTO_URL,
  'RAX_REGION'   => 'ORD' # Could select randomly
  # HOME is used to find SSH key - may need to be fixed for Windows
}

def findScript(test_name)
  file = Dir.glob("**/*#{test_name}.*", File::FNM_CASEFOLD).first ||
    Dir.glob("**/*#{test_name.gsub(' ', '')}.*", File::FNM_CASEFOLD).first
  raise "Could not find script for #{test_name}" if file.nil? or !File.readable?(file)
  file
end

def runSuite(suite_name, tests, env, options = {})
  describe suite_name do
    test_env = STANDARD_ENV_VARS.merge(env)
    tests.each do |test|
      it test do
        script = findScript test
        cmd = Mixlib::ShellOut.new("bundle exec ruby #{script}", :env => test_env, :live_stream => $stdout, :timeout => 20 * MINUTES)
        cmd.run_command # etc.
        cmd.error! unless options[:allow_errors]
      end
    end
  end
end

# I might have these run both before and as part of the suite
runSuite("Cleanup", %w{delete_keypair detach_volume delete_server delete_container}, {
  'CONFIRM_DELETE' => 'y',
  'CREATE_KEYPAIR_NAME' => 'my_test_keypair',
  'UPLOAD_KEYPAIR_NAME' => 'my_uploaded_keypair',
  'SERVER_NAME' => 'my_test_server',
  'VOLUME_NAME' => 'my_test_volume',
  'ATTACHMENT_NAME' => '/dev/xvdb',
  'REMOTE_DIRECTORY' => 'automated_test_dir' # for delete_container
}, :allow_errors => true)

# delete_server is missing
# resizing server with an attached volume is an interesting scenario
runSuite("Compute", %w{create_keypair create_server resize_server attach_volume detach_volume}, {
  'CONFIRM_DELETE' => 'y',
  'CREATE_KEYPAIR_NAME' => 'my_test_keypair',
  'UPLOAD_KEYPAIR_NAME' => 'my_uploaded_keypair',
  'SERVER_NAME' => 'my_test_server',
  'SERVER_SIZE' => '1 GB Performance',
  'SERVER_RESIZE' => '2 GB Performance',
  'VOLUME_NAME' => 'my_test_volume',
  'ATTACHMENT_NAME' => '/dev/xvdb'
})

# temporarily remove 
runSuite("Storage", %w{create_container upload_file upload_directory change_metadata get_file delete_container}, {
  'REMOTE_DIRECTORY' => 'automated_test_dir',
  'LOCAL_DIRECTORY'  => 'tmp/storage',
  'REMOTE_FILE'      => 'sample.txt',
  'UPLOAD_DIRECTORY' => 'fixtures/sample_site'
})

runSuite("Queues", %w{create_queue add_message claim_messages delete_queue}, {
  'QUEUE_NAME' => 'test_queue',
  'MSGS_TO_CLAIM' => '5',
})
