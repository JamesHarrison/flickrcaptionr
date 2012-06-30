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
      for key in %w(url thumbnail_url)
        if resp[key] and resp[key] != nil
          return resp[key]
        end
      end
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