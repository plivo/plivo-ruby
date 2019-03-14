module Plivo
  module XML
    class Phoneme < Element
      @nestables = []
      @valid_attributes = %w(alphabet ph)

      def initialize(body, attributes = {})
        unless attributes && attributes[:ph]
          raise PlivoXMLError, 'ph attribute is required for Phoneme'
        end
        super(body, attributes)
      end
    end
  end
end
