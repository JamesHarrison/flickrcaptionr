require 'digest/sha1'
require 'dimensions'
class Flickrcaptionr::Processor
  def initialize
    Flickrcaptionr::Processor.has_dependencies?
  end
  # Resize an image, fitting the space provided as best as possible with a centre-weighted crop
  def resize!(path, width, height)
    out_filename = File.expand_path(path)
    # Now pull the basename out and add our size string
    out_filename = File.join(File.dirname(out_filename), File.basename(out_filename).gsub(/(.+)\.([A-Za-z0-9]{3,4})$/,'\1-'+"#{width.to_i.to_s}x#{height.to_i.to_s}"+'.\2'))
    if File.exists?(out_filename)
      puts "Not resizing, #{out_filename} already exists"
    else
      puts "Resizing #{path} to #{width.to_i.to_s}x#{height.to_i.to_s} at #{out_filename}"
      res = `convert #{path} -resize #{width.to_i.to_s}x#{height.to_i.to_s}^ -gravity center -extent #{width.to_i.to_s}x#{height.to_i.to_s} #{out_filename}`
    end
    return out_filename
  end
  # Add some funky macro text to an image.
  # Takes an optional hash of :font_path, :font_size and :font_stroke (defaults: bundled Coda Heavy font, 36, 2)
  def add_text!(path, text, opts={})
    out_filename = File.expand_path(path)
    # Now pull the basename out and add our size string
    out_filename = File.join(File.dirname(out_filename), File.basename(out_filename).gsub(/(.+)\.([A-Za-z0-9]{3,4})$/,'\1-'+Digest::SHA1.hexdigest(text+opts.to_s)+'.\2'))
    # Generate our text layer
    if File.exists?(out_filename)
      puts "Already added text to this image, not doing it again"
    else
      puts "Adding text '#{text}' to #{path}"
      `convert -background none -fill white -font "#{opts[:font_path] ? opts[:font_path] : (File.join(File.dirname(__FILE__), '..', '..', 'fonts', 'Coda-Heavy.ttf' ))}" -stroke black -strokewidth #{opts[:font_stroke] ? opts[:font_stroke].to_s : 2.to_s} -pointsize #{opts[:font_size] ? opts[:font_size].to_s : 36.to_s} -size #{((Dimensions.width(path)-10).to_s)}  -gravity Center caption:'#{text.gsub(/[^A-Za-z0-9 \-"\.,\?\!]/,"")}' caption-tmp.png`
      `composite caption-tmp.png #{path} -compose atop -gravity South #{out_filename}`
      `rm -rf caption-tmp.png`
    end
    return out_filename
  end
  # Checks for presence of required tools
  def self.has_dependencies?
    unless self.which('convert')
      raise SystemCallError, "ImageMagick is required to use this library.\nYou can install it on Ubuntu/Debian with 'sudo apt-get install imagemagick', or on OSX with 'port install ImageMagick'.\nSpecifically I need 'convert' in my PATH."
    end
    unless self.which('composite')
      raise SystemCallError, "ImageMagick is required to use this library.\nYou can install it on Ubuntu/Debian with 'sudo apt-get install imagemagick', or on OSX with 'port install ImageMagick'.\nSpecifically I need 'composite' in my PATH."
    end
  end
  private
  # Utility method to identify if a program is available and executable.
  # Basically a clone of the unix tool 'which'
  def self.which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      exts.each { |ext|
        bin = "#{path}/#{cmd}#{ext}"
        return bin if File.executable? bin
      }
    end
    return nil
  end
end