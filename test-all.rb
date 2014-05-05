#!/usr/bin/env ruby
require 'rspec'
require 'yaml'
require 'mixlib/shellout'

MINUTES = 60 # in seconds

STANDARD_ENV_VARS = {
  'RAX_USERNAME' => ENV['RAX_USERNAME'],
  'RAX_API_KEY'  => ENV['RAX_API_KEY'],
  # 'RAX_AUTH_URL' => PACTO_URL,
  'RAX_REGION'   => 'ORD' # Could select randomly
  # HOME is used to find SSH key - may need to be fixed for Windows
}

def find_script(test_name)
  file = Dir.glob("**/*#{test_name.gsub(' ', '')}.*", File::FNM_CASEFOLD).first ||
    Dir.glob("**/*#{test_name.gsub(' ', '_')}.*", File::FNM_CASEFOLD).first
  raise "Could not find script for #{test_name}" if file.nil? or !File.readable?(file)
  file
end

def setup_suite(suite_name, tests, env, options = {})
  describe suite_name do
    test_env = env.nil? ? STANDARD_ENV_VARS : STANDARD_ENV_VARS.merge(env)
    tests.each do |test|
      it test do
        script = find_script test
        cmd = Mixlib::ShellOut.new("bundle exec ruby #{script}", :env => test_env, :live_stream => $stdout, :input => $stdin, :timeout => 20 * MINUTES)
        cmd.run_command # etc.
        cmd.error! unless options[:allow_errors]
      end
    end
  end
end

polytrix_config = YAML::load(File.read('polytrix.yml'))
polytrix_config['suites'].each do |suite_name, suite_config|
  setup_suite(suite_name, suite_config['samples'], suite_config['env'])
end
