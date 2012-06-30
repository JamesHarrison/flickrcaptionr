require 'sinatra'
require 'haml'
class Flickrcaptionr::App < Sinatra::Base
  set :haml, format: :html5
  set :views, ::File.expand_path('../../../views', __FILE__)
  @@public_files = {
    "bootstrap.min.css" => "text/css"
  }
  helpers do 
    include Rack::Utils
    alias_method :h, :escape_html
  end
  get '/' do
    haml :index
  end
  get '/get/:image_url/:image_width/:image_height/:caption_text' do
    @f ||= Flickrcaptionr::Fetcher.new
    @p ||= Flickrcaptionr::Processor.new
    # {"image_url"=>"https://secure.flickr.com/photos/must_love_cartoons/7474524298/",
    #  "image_width"=>"300", "image_height"=>"400", 
    #  "caption_text"=>"You have angered the developer", "caption_font_size"=>"36", "caption_font_stroke"=>"2"}

    if params['image_url'] and params['image_url'].size > 0
      caption_opts = {}
      if params['caption_text'] and params['caption_text'] != ''
        caption_opts[:font_size] = params['caption_font_size'].to_i if params['caption_font_size'] and params['caption_font_size'].size > 0
        caption_opts[:font_stroke] = params['caption_font_stroke'].to_i if params['caption_font_stroke'] and params['caption_font_stroke'].size > 0
      end
      begin
        file = @f.fetch(params['image_url'])
        w = params['image_width'].to_i
        h = params['image_height'].to_i
        if w > 0 and h > 0
          file = @p.resize!(file, w, h)
        end
        file = @p.add_text!(file, params['caption_text'], caption_opts) if params['caption_text'] and params['caption_text'] != ''
        send_file file
      rescue Exception => e
        params['error'] = e.message
      end
    else
      params['error'] = "You didn't supply a URL. Not sure what you expect me to do without that."
    end
    haml :index
  end
  post '/' do
    @f ||= Flickrcaptionr::Fetcher.new
    @p ||= Flickrcaptionr::Processor.new
    # {"image_url"=>"https://secure.flickr.com/photos/must_love_cartoons/7474524298/",
    #  "image_width"=>"300", "image_height"=>"400", 
    #  "caption_text"=>"You have angered the developer", "caption_font_size"=>"36", "caption_font_stroke"=>"2"}

    if params['image_url'] and params['image_url'].size > 0
      
      caption_opts = {}
      if params['caption_text'] and params['caption_text'] != ''
        caption_opts[:font_size] = params['caption_font_size'].to_i if params['caption_font_size'] and params['caption_font_size'].size > 0
        caption_opts[:font_stroke] = params['caption_font_stroke'].to_i if params['caption_font_stroke'] and params['caption_font_stroke'].size > 0
      end
      begin
        file = @f.fetch(params['image_url'])
        w = params['image_width'].to_i
        h = params['image_height'].to_i
        if w > 0 and h > 0
          file = @p.resize!(file, w, h)
        end
        file = @p.add_text!(file, params['caption_text'], caption_opts) if params['caption_text'] and params['caption_text'] != ''
        redirect "/image/#{File.basename(file)}"
      rescue Exception => e
        params['error'] = e.message
      end
      
    else
      params['error'] = "You didn't supply a URL. Not sure what you expect me to do without that."
    end
    haml :index
  end
  get '/image/:filename' do
    send_file File.join(Flickrcaptionr::Config.output_path, params['filename'])
  end
  get '/favicon.ico' do
    ""
  end
  @@public_files.each do |public_file, public_file_type|
    get "/#{public_file}" do
      content_type(public_file_type)
      ::File.open(::File.expand_path("../../../pub/#{public_file}", __FILE__)).read
    end
  end
end