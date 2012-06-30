# -*- encoding: utf-8 -*-
require File.expand_path('../lib/flickrcaptionr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["James Harrison"]
  gem.email         = ["james@talkunafraid.co.uk"]
  gem.description   = %q{flickrcaptionr generates images, given a Flickr or other oEmbed-supported source, at the resolution of your choice and optionally with image-macro-style captions}
  gem.summary       = %q{flickrcaptionr turns Flickr images into (optionally) captioned thumbnails}
  gem.homepage      = "http://github.com/JamesHarrison/flickrcaptionr"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.name          = "flickrcaptionr"
  gem.require_paths = ["lib"]
  gem.version       = Flickrcaptionr::VERSION

  gem.add_dependency("ruby-oembed", ">= 0.8.7")
  gem.add_dependency("trollop", ">= 1.16.2")
  gem.add_dependency("dimensions", ">= 1.2.0")
  gem.add_dependency("sinatra", ">= 1.3.2")
  gem.add_dependency("haml", ">= 3.1.6")
  gem.add_dependency("thin", ">= 1.3.1")
end