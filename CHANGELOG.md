# Changelog

## 1.1.0 - 1st July 2012

### Bugfixes

* Flickr fetcher was greedily picking up on some non-flickr URLs
* Spaces in image names no longer result in abject failure
* Quotes are now properly escaped in text (single and double)
* OEmbed API fetcher wouldn't work for some response types

### Features

* Tests - RSpec suite to cover the basics added (fetcher, processor)