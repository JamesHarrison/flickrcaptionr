require 'spec_helper'
describe Flickrcaptionr::Processor do
  before(:each) do
    @fetcher = Flickrcaptionr::Fetcher.new
    @processor = Flickrcaptionr::Processor.new
    @path = @fetcher.fetch("6630238837")
  end
  after(:all) do
    File.delete(@path)
  end

  it "can resize an image to a smaller size" do
    path = @processor.resize!(@path, 320, 240)
    File.exists?(path).should be_true
    Dimensions.width(path).should eq(320)
    Dimensions.height(path).should eq(240)
    File.delete(path)
  end
  
  it "can enlarge an image" do
    path = @processor.resize!(@path, 3200, 2400)
    File.exists?(path).should be_true
    Dimensions.width(path).should eq(3200)
    Dimensions.height(path).should eq(2400)
    File.delete(path)
  end

  it "can overlay text on an image" do
    path = @processor.add_text!(@path, "Hello, world!")
    File.exists?(path).should be_true
  end

  it "can overlay text with double quotes on an image" do
    path = @processor.add_text!(@path, "\"Hello, world!\"")
    File.exists?(path).should be_true
  end

  it "can overlay text with single quotes on an image" do
    path = @processor.add_text!(@path, "'Hello, world!'")
    File.exists?(path).should be_true
  end

  it "can overlay text on an image when faced with blank input" do
    path = @processor.add_text!(@path, "")
    File.exists?(path).should be_true
  end

  it "can overlay text on an image when faced with nasty characters" do
    path = @processor.add_text!(@path, '#\{32asdAS~!~5"l}')
    File.exists?(path).should be_true
  end

end
