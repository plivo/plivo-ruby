require_relative "resources"
require_relative "base_client"
require_relative "base"

module Plivo
  class RestClient < BaseClient

    # Resources
    attr_reader :messages, :account, :subaccounts, :recordings
    attr_reader :pricings, :numbers, :calls, :conferences
    attr_reader :token
    attr_reader :phone_numbers, :applications, :endpoints, :multipartycalls
    attr_reader :addresses, :identities
    attr_reader :call_feedback
    attr_reader :powerpacks
    attr_reader :powerpacks, :media
    attr_reader :lookup
    attr_reader :brand, :campaign, :profile
    attr_reader :end_users
    attr_reader :compliance_document_types, :compliance_documents, :compliance_requirements, :compliance_applications

    def initialize(auth_id = nil, auth_token = nil, proxy_options = nil, timeout = 5)
      configure_base_uri
      super
      configure_interfaces
    end

    private

    def configure_base_uri
      @base_uri = Base::PLIVO_API_URL
      @voice_base_uri = Base::API_VOICE
      @voice_base_uri_fallback_1 = Base::API_VOICE_FALLBACK_1
      @voice_base_uri_fallback_2 = Base::API_VOICE_FALLBACK_2
      @callinsights_base_uri = Base::CALLINSIGHTS_API_URL
      @lookup_base_uri = Base::LOOKUP_API_URL
    end

    def configure_interfaces
      @account = Resources::AccountInterface.new(self)
      @messages = Resources::MessagesInterface.new(self)
      @powerpacks = Resources::PowerpackInterface.new(self)
      @media = Resources::MediaInterface.new(self)
      @brand = Resources::BrandInterface.new(self)
      @campaign = Resources::CampaignInterface.new(self)
      @profile = Resources::ProfileInterface.new(self)
      @subaccounts = Resources::SubaccountInterface.new(self)
      @recordings = Resources::RecordingInterface.new(self)
      @pricings = Resources::PricingInterface.new(self)
      @numbers = Resources::NumberInterface.new(self)
      @phone_numbers = Resources::PhoneNumberInterface.new(self)
      @conferences = Resources::ConferenceInterface.new(self)
      @calls = Resources::CallInterface.new(self)
      @token = Resources::TokenInterface.new(self)
      @endpoints = Resources::EndpointInterface.new(self)
      @applications = Resources::ApplicationInterface.new(self)
      @addresses = Resources::AddressInterface.new(self)
      @identities = Resources::IdentityInterface.new(self)
      @call_feedback = Resources::CallFeedbackInterface.new(self)
      @multipartycalls = Resources::MultiPartyCallInterface.new( self)
      @lookup = Resources::LookupInterface.new(self)
      @end_users = Resources::EndUsersInterface.new(self)
      @compliance_document_types = Resources::ComplianceDocumentTypesInterface.new(self)
      @compliance_documents = Resources::ComplianceDocumentsInterface.new(self)
      @compliance_requirements = Resources::ComplianceRequirementsInterface.new(self)
      @compliance_applications = Resources::ComplianceApplicationsInterface.new(self)
    end
  end
end
