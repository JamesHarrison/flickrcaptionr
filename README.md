# flickrcaptionr

flickrcaptionr is a gem which lets you easily retrieve images (from flickr and other sources), resize them (cropping etc as desired), and overlay classic "image macro" text on them.

It can be used as a web service, command-line tool or as a library in your application.

You will need your own API key for flickr if you want to get images from there. oEmbed API enabled sources are also supported, such as tumblr, for which an API key is not required (but source image resolutions may be limited). Direct image URLs can also be passed to the application for resizing and thumbnailing.

## Dependencies

flickrcaptionr has no non-gem dependencies other than ImageMagick's convert tool, Ruby 1.9 or greater (1.9.3 recommended) and the standard Ruby net/http library.

On Ubuntu systems, ImageMagick can be installed with:

    sudo apt-get install imagemagick

On Mac systems, ImageMagick can be installed with:

    sudo port install ImageMagick

You can check everything is working by running `convert -version`. If you see something like `Version: ImageMagick 6.6.0-4 2012-04-30 Q16 http://www.imagemagick.org`, everything is probably just fine. Greater version numbers are untested, but anything newer than 6.4.x the line *should* work fine.


## Installation

Add this line to your application's Gemfile:

    gem 'flickrcaptionr'

And then execute:

    $ bundle

Or install it standalone as:

    $ gem install flickrcaptionr

## Usage

To fetch, resize and caption images from the command line use:

    $ flickrcaptionr-cli [options] url

To provide a web service, spin up the webapp with:

    $ flickrcaptionr-web [options]

Point your browser at the URL given in the output, typically `http://localhost:4567`. You'll probably want to read the help on these.

Configuration for flickrcaptionr is stored in a Yaml file, by default at ~/.flickrcaptionr.yml. You can change this if you like. The CLI or web tools can create this file for you, and set options in it. For instance, to set your Flickr API key:

    $ flickrcaptionr-cli -f 21k41poj52oi5j3oj522oj5i3

You only need to do this once and then you're set.

A more comprehensive example of the CLI follows:

    $ flickrcaptionr-cli --caption-font-size=48 --caption "BLUE. BLUE EVERYWHERE." \
      --resize 400x400 "http://assets.talkunafraid.co.uk/img/IMG_0311.jpg"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

See the LICENSE file. Long story short, MIT, go crazy.