require_relative 'base/resource_interface'
require_relative 'base/resource'
require_relative 'base/response'

module Plivo
  module Base
    PLIVO_API_URL = 'https://api.plivo.com'.freeze

    API_VOICE = 'https://api-voice.plivo.com'.freeze
    API_VOICE_FALLBACK_1 = 'https://api-voice-usw1.plivo.com'.freeze
    API_VOICE_FALLBACK_2 = 'https://api-voice-use1.plivo.com'.freeze

    CALLINSIGHTS_API_URL = 'https://stats.plivo.com'.freeze
    PHLO_API_URL = 'https://phlorunner.plivo.com'.freeze
  end
end
