# frozen_string_literal: true

$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")

require "minitest/autorun"
require "minitest/reporters"
require "webmock/minitest"

require "data_wrangler"

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

def fixtures_path
  "#{File.dirname(__FILE__)}/fixtures"
end

def configuration_path(filename)
  File.join(fixtures_path, "configurations", filename)
end

def csv_path(filename)
  "#{fixtures_path}/csv/#{filename}"
end

def record(data)
  DataWrangler::Book::Record.new(data)
end

def txt_path(filename)
  "#{fixtures_path}/txt/#{filename}"
end

def xls_path(filename)
  "#{fixtures_path}/xls/#{filename}"
end

def xlsx_path(filename)
  "#{fixtures_path}/xlsx/#{filename}"
end

def books_config(key = "books")
  DataWrangler::Configuration::Book.new(
    configuration_path("books.yml"),
    key: key
  )
end

def editorial_config(key = "editorial_stills_default")
  DataWrangler::Configuration::Book.new(
    configuration_path("editorial_stills.yml"),
    key: key
  )
end

def creative_stills_config(key = "ipw_standard")
  DataWrangler::Configuration::Book.new(
    configuration_path("creative_stills.yml"),
    key: key
  )
end

def creative_video_config(key = "nyc_market_log")
  DataWrangler::Configuration::Book.new(
    configuration_path("creative_video.yml"),
    key: key
  )
end

def load_configuration(filename:, key:)
  configuration = configuration_path(filename)
  config = YAML.load_file(configuration)
  config[key]
end

def image_metadata_wrangler
  filepath = xlsx_path("image_metadata.xlsx")
  config = configuration_path("image_metadata.yml")
  DataWrangler::Wrangler.new(filepath, configpath: config, key: "image_metadata")
end
