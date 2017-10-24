module Plivo
  module XML
    class Number < Element
      @nestables = []
      @valid_attributes = %w[sendDigits sendOnPreanswer]

      def initialize(body, attributes = {})
        raise PlivoXMLError, 'No number set for Number' unless body
        super(body, attributes)
      end
    end
  end
end
