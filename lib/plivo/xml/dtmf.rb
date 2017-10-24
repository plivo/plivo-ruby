module Plivo
  module XML
    class DTMF < Element
      @nestables = []
      @valid_attributes = %w[async]

      def initialize(body, attributes = {})
        raise PlivoXMLError, 'No digits set for DTMF' unless body
        super(body, attributes)
      end
    end
  end
end
