module Plivo
  module XML
    class Speak < Element
      @nestables = []
      @valid_attributes = %w[voice language loop]

      def initialize(body, attributes = {})
        if !body
          raise PlivoXMLError, 'No text set for Speak'
        else
          body = HTMLEntities.new(:html4).encode(body, :decimal)
        end
        super(body, attributes)
      end
    end
  end
end
