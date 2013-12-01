
module Plivo

  # Override of Faraday::Error::ClientError to provide more information
  # for 400-600 status codes.
  class ClientError < Faraday::Error::ClientError
    def initialize(ex, response = nil)
      if ex.respond_to?(:each_key)
        super("the server responded with status #{ex[:status]}. Error Message: #{ex[:body]}")
      else
        super
      end
    end
  end
end