module Plivo

  # @see http://plivo.com/docs/api/numbers/availablenumbergroup/
  class AvailableNumberGroup < Resource

    # Search for new numbers.
    #
    # @see http://plivo.com/docs/api/numbers/availablenumbergroup/#number_search
    #
    # @param [Hash] opts
    # @option opts [String] country_iso two letter country code. E.g. "US", "UK"
    #   Required.
    # @option opts [String] number_type 'local', 'national' or 'tollfree'.
    #   Defaults to 'local'.
    # @option opts [String] services comma-separated list of features. Set to
    #   'voice', 'sms' or 'voice,sms' to search numbers with the respective
    #   features available.
    # @option opts [String] region Region in which to search for numbers.
    #   Both region codes ('NY', 'CA') or region names ('New York', 'California')
    #   may be used. Only applicable for 'local' numbers.
    # @option opts [String] prefix A number prefix to filter by. Max length
    #   of 5 digits.
    #
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
