require_relative 'resources'
require_relative 'base_client'
require_relative 'base'

module Plivo
  class RestClient < BaseClient

    # Resources
    attr_reader :messages, :account, :subaccounts, :recordings
    attr_reader :pricings, :numbers, :calls, :conferences
    attr_reader :phone_numbers, :applications, :endpoints
    attr_reader :addresses, :identities

    def initialize(auth_id = nil, auth_token = nil, proxy_options = nil, timeout=5)
      configure_base_uri
      super
      configure_interfaces
    end

    private

    def configure_base_uri
      @base_uri = Base::PLIVO_API_URL
    end

    def configure_interfaces
      @account = Resources::AccountInterface.new(self)
      @messages = Resources::MessagesInterface.new(self)
      @subaccounts = Resources::SubaccountInterface.new(self)
      @recordings = Resources::RecordingInterface.new(self)
      @pricings = Resources::PricingInterface.new(self)
      @numbers = Resources::NumberInterface.new(self)
      @phone_numbers = Resources::PhoneNumberInterface.new(self)
      @conferences = Resources::ConferenceInterface.new(self)
      @calls = Resources::CallInterface.new(self)
      @endpoints = Resources::EndpointInterface.new(self)
      @applications = Resources::ApplicationInterface.new(self)
      @addresses = Resources::AddressInterface.new(self)
      @identities = Resources::IdentityInterface.new(self)
    end
  end
end
