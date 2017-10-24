module Plivo
  module XML
    class Message < Element
      @nestables = []
      @valid_attributes = %w[src dst type callbackUrl callbackMethod]

      def initialize(body, attributes = {})
        raise PlivoXMLError, 'No text set for Message' unless body
        super(body, attributes)
      end
    end
  end
end
