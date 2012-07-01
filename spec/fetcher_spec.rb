require 'spec_helper'
describe Flickrcaptionr::Fetcher do
  before(:each) do
    @fetcher = Flickrcaptionr::Fetcher.new
  end
  it "fetches an image given a Flickr photo ID" do
    path = @fetcher.fetch("6630238837")
    File.exists?(path).should be_true
    File.delete(path)
  end

  it "fetches an image given a Flickr photo URL" do
    path = @fetcher.fetch("http://flickr.com/photos/james_harrison/6630238837/in/photostream")
    File.exists?(path).should be_true
    File.delete(path)
  end

  it "fetches an image given a direct image URL" do
    path = @fetcher.fetch("http://assets.talkunafraid.co.uk/img/wish_you_were_partying_by_purpletinker-d3fjcgw.png.jpg")
    File.exists?(path).should be_true
    File.delete(path)
  end

  it "fetches an image given an OEmbed API supported address" do
    path = @fetcher.fetch("http://www.youtube.com/watch?v=UzsxfO7dBlA")
    File.exists?(path).should be_true
    File.delete(path)
  end
end
