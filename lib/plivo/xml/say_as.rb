module Plivo
  module XML
    class SayAs < Element
      @nestables = []
      @valid_attributes = %w(interpret-as format)

      def initialize(body, attributes = {})
        unless attributes && attributes["interpret-as"]
          raise PlivoXMLError, 'interpret-as is a required attribute for say-as element'
        end
        super(body, attributes)
      end
    end
  end
end
