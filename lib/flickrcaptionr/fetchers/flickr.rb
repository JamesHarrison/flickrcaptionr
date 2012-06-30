require 'json'
# NOTE: Since flickr is the main service this is designed for, this will catch anything
# that looks like a number on its own as a URL (no http:// or anything) to treat as a
# Flickr Photo ID.
class Flickrcaptionr::Fetchers::Flickr < Flickrcaptionr::Fetchers::Base
  def initialize
    @@api_key = Flickrcaptionr::Config.flickr_api_key
    @@flickr_regexes = [/(?!www\.flickr.com|secure\.flickr.com|flickr.com).+\/(\d+)\/.*/,/^(\d+)$/]
  end
  def fetch(url)
    unless @@api_key
      raise Flickrcaptionr::FetcherNotConfiguredException, "Flickr API requires an API key! Configure one in your configuration file."
    end
    photo_id = nil
    @@flickr_regexes.each do |regex|
      md = regex.match(url)
      if md
        photo_id = md[1]
      end 
    end
    unless photo_id
      raise Flickrcaptionr::RequestNotFetchableException, "Could not retrieve #{url}, couldn't figure out the photo ID from that URL"
    end
    api_req_uri = URI.parse("http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&format=json&api_key=#{@@api_key}&photo_id=#{photo_id.to_s}")
    api_data = {}
    begin
      api_resp = Net::HTTP.get_response(api_req_uri) # Fetch it
      api_data = JSON.load(api_resp.body.gsub("jsonFlickrApi(","")[0..-2]) # Note we have to remove the JSONP chunks here so Ruby's JSON lib will parse it
    rescue Exception => e
      raise Flickrcaptionr::RequestNotFetchableException, "Could not retrieve #{url}, API request failed (underlying request URL #{api_req_uri.inspect})\n#{e.inspect}\n#{e.backtrace}"
    end
    # We now have data!
    if api_data['stat'] != 'ok'
      raise Flickrcaptionr::RequestNotFetchableException, "Could not retrieve #{url}, API request returned an error from Flickr! (underlying request URL #{api_req_uri.inspect}, response was #{api_data.inspect})"
    end
    if api_data['sizes']['candownload'] != 1
      raise Flickrcaptionr::RequestNotFetchableException, "Could not retrieve #{url}, image requested is not downloadable"
    end
    # We've now made sure we can fetch these.
    # Okay, now we want the biggest image we can lay our hands on.
    img = api_data['sizes']['size'].sort_by{|s|s['width'].to_i}.reverse[0]
    return img['source']
  end
  def can_handle_url?(url)
    @@flickr_regexes.each do |regex|
      if regex.match(url)
        if @@api_key
          return true
        else
          raise Flickrcaptionr::FetcherNotConfiguredException, "Flickr API requires an API key!"
        end
      end
    end
    return false
  end
end