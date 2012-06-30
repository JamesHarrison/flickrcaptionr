require 'net/http'
require 'uri'
# Base Fetcher, all others inherit from this. Don't use it directly - it won't do anything.
class Flickrcaptionr::Fetchers::Base
  # Setup the fetcher
  def initialize

  end
  # Resolve the exact file URL to download
  def fetch(url)
  end
  # Downloads a file to a given location using a simple HTTP GET
  def download_file(url, out_path)
    uri = URI(url)
    resp = Net::HTTP.get_response(uri)
    open(out_path, "wb"){|f| f.write(resp.body) }
  end
  # Should return true if a given URL can be handled by this fetcher.
  def can_handle_url?(url)
    return false
  end
end