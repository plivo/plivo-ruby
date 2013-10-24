module Plivo
  # @see http://plivo.com/docs/api/numbers/number/
  class RentedNumber < Resource
    self.resource_name = 'Number'

    # Unrent a number
    #
    # @return [Faraday::Response]
    def unrent
      client.request('DELETE', uri)
    end

    # Find a RentedNumber by the number instead of a uri
    #
    # @see http://plivo.com/docs/api/numbers/number/#number_detail
    #
    # @param [String] number_or_uri a phone number or a resource URI
    # @return [Plivo::RentedNumber]
    def self.find(number_or_uri)
      if number_or_uri =~ /^\//
        super
      else
        super("Number/#{number_or_uri}/")
      end
    end
  end
end