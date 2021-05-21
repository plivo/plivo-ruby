module Plivo
  module XML
    class Sub < Element
      @nestables = []
      @valid_attributes = %w(alias)

      def initialize(body, attributes = {})
        raise PlivoXMLError, 'No text set for sub element' unless body
        unless attributes && attributes[:alias]
          raise PlivoXMLError, 'alias is a required attribute for sub element'
        end
        super(body, attributes)
      end
    end
  end
end
