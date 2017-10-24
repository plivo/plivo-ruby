module Plivo
  module Resources
    include Plivo::Utils
    class Pricing < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Pricing'
        @_identifier_string = 'country_iso'
        super
      end

      def to_s
        {
          api_id: @api_id,
          country: @country,
          country_code: @country_code,
          country_iso: @country_iso,
          message: @message,
          phone_numbers: @phone_numbers,
          voice: @voice
        }.to_s
      end
    end

    class PricingInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Pricing'
        @_resource_type = Pricing
        @_identifier_string = 'country_iso'
        super
      end

      # @param [String] country_iso
      def get(country_iso)
        valid_param?(:country_iso, country_iso, [String, Symbol], true)
        unless country_iso.length == 2
          raise_invalid_request('country_iso should be of length 2')
        end
        params = { country_iso: country_iso }
        perform_get_without_identifier(params)
      end
    end
  end
end
