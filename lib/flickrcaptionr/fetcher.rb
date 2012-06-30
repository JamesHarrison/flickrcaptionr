class Flickrcaptionr::Fetcher
  def initialize(fetchers=[])
    if not fetchers or (fetchers and fetchers.size == 0)
      fetchers = [Flickrcaptionr::Fetchers::Flickr, Flickrcaptionr::Fetchers::OEmbed]
    end
    @fetchers = []
    # Spin up each fetcher
    for f in fetchers
      @fetchers.push(f.new)
    end
  end
  def fetch(url)
    puts "Fetching #{url}..."
    for f in @fetchers
      if f.can_handle_url?(url)
        to_get = f.fetch(url)
        return do_fetch(to_get, f)
      end
    end
    # If none of the matchers hit it but we appear to be a direct image URL, just go get it!
    if /^.+\.(png|gif|jpg|jpeg)$/i.match(url)
      return do_fetch(url, Flickrcaptionr::Fetchers::Base.new)
    end
    raise Flickrcaptionr::RequestNotFetchableException, "Couldn't find any suitable image fetcher for this URL. Try supplying a direct image URL if possible."
  end
  def do_fetch(to_get, fetcher)
    out_name = File.basename(to_get)
    if !Flickrcaptionr::Config.output_path or Flickrcaptionr::Config.output_path == ''
      out_name = File.join(Dir.pwd, out_name)
    else
      out_name = File.join(Flickrcaptionr::Config.output_path, out_name)
    end
    unless File.exists?(out_name)
      puts "Downloading #{to_get}..."
      fetcher.download_file(to_get, out_name)
      puts "Written file to #{out_name}"
    else
      puts "Already got #{to_get}, not redownloading"
    end
    return out_name
  end
end