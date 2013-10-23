require 'rubygems'
require 'bundler'
require 'dotenv'

Dotenv.load

Bundler.setup :default, :test
Bundler.require :default, :test

require 'mocha/api'

$:.push File.expand_path(File.dirname(__FILE__))

AUTH_ID = ENV['PLIVO_AUTH_ID']
AUTH_TOKEN = ENV['PLIVO_AUTH_TOKEN']

RSpec.configure do |config|
  config.mock_with :mocha

  config.order = "random"

  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:suite) do
    Plivo::RestAPI.configure(AUTH_ID, AUTH_TOKEN)
  end

  def collection_response
    Faraday::Response.new(
      body: {'objects' => [{'id' => 123}]}
    )
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    :record => :new_episodes
  }
end