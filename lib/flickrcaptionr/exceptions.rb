class Flickrcaptionr::RequestNotFetchableException < ArgumentError; end
class Flickrcaptionr::FetcherNotConfiguredException < ArgumentError; end
class Flickrcaptionr::ResizeFailedException < ArgumentError; end
class Flickrcaptionr::TextGenerationFailedException < ArgumentError; end
class Flickrcaptionr::CompositionFailedException < ArgumentError; end