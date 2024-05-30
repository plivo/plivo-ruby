require_relative 'base/resource_interface'
require_relative 'base/resource'
require_relative 'base/response'

module Plivo
  module Base
    PLIVO_API_URL = 'https://domino-qa.voice.plivodev.com'.freeze

    API_VOICE = 'https://domino-qa.voice.plivodev.com'.freeze
    API_VOICE_FALLBACK_1 = 'https://domino-qa.voice.plivodev.com'.freeze
    API_VOICE_FALLBACK_2 = 'https://domino-qa.voice.plivodev.com'.freeze

    CALLINSIGHTS_API_URL = 'https://stats.plivo.com'.freeze
    PHLO_API_URL = 'https://phlorunner.plivo.com'.freeze
    LOOKUP_API_URL = 'https://lookup.plivo.com'.freeze
  end
end