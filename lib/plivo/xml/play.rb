module Plivo
  module XML
    class Play < Element
      @nestables = []
      @valid_attributes = %w[loop]

      def initialize(body, attributes = {})
        raise PlivoXMLError 'No url set for Play' unless body
        super(body, attributes)
      end
    end
  end
end
