module Plivo
  module XML
    class User < Element
      @nestables = []
      @valid_attributes = %w[sendDigits sendOnPreanswer sipHeaders]

      def initialize(body, attributes = {})
        raise PlivoXMLError, 'No user set for User' unless body
        super(body, attributes)
      end
    end
  end
end
