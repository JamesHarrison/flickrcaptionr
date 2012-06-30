require "rubygems"
require "bundler/setup"
require "flickrcaptionr/version"

module Flickrcaptionr
  module Fetchers
  end
end
require 'flickrcaptionr/config'
require 'flickrcaptionr/exceptions'
require 'flickrcaptionr/processor'
require 'flickrcaptionr/fetchers/base'
require 'flickrcaptionr/fetchers/flickr'
require 'flickrcaptionr/fetchers/oembed'
require 'flickrcaptionr/fetcher'
require 'flickrcaptionr/app'