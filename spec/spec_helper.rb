dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

# Don't want puppet getting the command line arguments for rake or autotest
ARGV.clear

require 'puppetlabs_spec_helper/puppet_spec_helper'
require 'puppet'
require 'facter'
require 'mocha'
gem 'rspec', '>=2.0.0'
require 'rspec/expectations'



RSpec.configure do |config|
  config.before :each do
    GC.disable
  end

  config.after :each do
    GC.enable
  end
end
