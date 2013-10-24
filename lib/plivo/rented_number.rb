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
    # @param [String] number a phone number
    # @return [Plivo::RentedNumber]
    def self.find(number)
      super("Number/#{number}/")
    end
  end
end