require_relative 'resources'
require_relative 'base_client'
require_relative 'base'

module Plivo

  class Phlo < BaseClient

    # Resources
    attr_reader :phlo

    def initialize(auth_id = nil, auth_token = nil, proxy_options = nil, timeout=5)
      configure_base_uri
      super
      configure_interfaces
    end

    private

    def configure_base_uri
      @base_uri = Base::PHLO_API_URL
    end

    def configure_interfaces
      @phlo = Resources::PhloInterface.new(self)
    end

  end
end
