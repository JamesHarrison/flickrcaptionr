require 'rubygems'
require 'bundler/setup'

require 'flickrcaptionr'

RSpec.configure do |config|
  config.before(:suite) { Flickrcaptionr::Config.new(File.expand_path('../flickrcaptionr.yml', __FILE__)) }
end