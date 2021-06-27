# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("lib", __dir__)

require "data_wrangler/version"

Gem::Specification.new do |s|
  s.license = "MIT"
  s.name = "datawrangler"
  s.version = DataWrangler.version
  s.date = "2016-11-22"
  s.summary = "Data handler"
  s.description = "Comprehensive extract, transform, validate and load workflow for tabulated data files"
  s.requirements << ""
  s.authors = ["Tim Davies"]
  s.email = "tim.davies@gettyimages.com"
  s.files = Dir["README.md", "Rakefile", "lib/**/*", "resources/**/*"]
  s.required_ruby_version = ">= 2.3.0"

  s.add_dependency "charlock_holmes_bundle_icu"
  s.add_dependency "creek"
  s.add_dependency "spreadsheet"

  s.add_development_dependency "benchmark-ips"
  s.add_development_dependency "benchmark-memory"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-minitest"
  s.add_development_dependency "guard-rubocop"
  s.add_development_dependency "minitest-reporters"
  s.add_development_dependency "rb-readline"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "standard"
  # s.add_development_dependency 'guard-standardrb'
  s.add_development_dependency "webmock"
end
