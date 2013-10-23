module Plivo

  # @see http://plivo.com/docs/api/numbers/availablenumbergroup/
  class AvailableNumberGroup < Resource
    # @return [ResourceCollection]
    def self.search(opts = {})
      ResourceCollection.new(client.get_number_group(opts), self)
    end

    # Rent one or more phone numbers.
    #
    # @see http://plivo.com/docs/api/numbers/availablenumbergroup/#rent_number
    #
    # @param [Hash] opts
    # @option opts [String] app_id application id to assign the number to.
    #   Defaults to the default application.
    # @option opts [Integer] quantity the quantity of of numbers to purchase.
    #   Defaults to 1.
    #
    # @return [Hash] hash representing the number details
    def rent(opts = {})
      response = client.rent_from_number_group(opts.merge('group_id' => group_id))
      response.body
    end
  end
end