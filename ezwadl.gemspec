require File.expand_path("../lib/ezwadl/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "ezwadl"
  s.version     = EzWadl::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Clement"]
  s.email       = ["clemenc@upenn.edu"]
  s.homepage    = "https://github.com/upenn-libraries/ezwadl"
  s.summary     = "The EzWadl gem provides easy access to the resources defined by a WADL."
  s.description = "The EzWadl gem provides easy access to the resources defined by a WADL."
  s.license     = "Apache 2.0"

  s.add_dependency "nokogiri", "~> 1.6"
  s.add_dependency "httparty", "~> 0.14"

  s.files        = Dir["{lib}/**/*.rb", "LICENSE", "*.md"]
  s.require_paths = ["lib"]

end
