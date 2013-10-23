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
  end
end