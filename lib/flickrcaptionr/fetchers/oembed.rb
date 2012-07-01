require 'oembed'
class Flickrcaptionr::Fetchers::OEmbed < Flickrcaptionr::Fetchers::Base
  def initialize
    OEmbed::Providers.register_all
  end
  def fetch(url)
    # OEmbed::Providers.get("https://www.youtube.com/watch?v=mNrXMOSkBas")
    # Try and fetch this URL
    resp = OEmbed::Providers.get(url)
    # Now figure out what the heck in our oembed response is actually the image we're seeking
    if resp
      return resp.url if (resp.url rescue nil)
      return resp.thumbnail_url if (resp.thumbnail_url rescue nil)
    end
    # If we're here, we either didn't retrieve any suitable image URL, or our provider broke
    raise Flickrcaptionr::RequestNotFetchableException, "Could not retrieve #{url}"
  end
  def can_handle_url?(url)
    OEmbed::Providers.urls.each_pair do |k,v|
      if k.match(url)
        return true
      end
    end
    return false
  end
end