module Plivo
  module XML
    class Redirect < Element
      @nestables = []
      @valid_attributes = ['method']

      def initialize(body, attributes = {})
        raise PlivoError 'No url set for Redirect' unless body
        super(body, attributes)
      end
    end
  end
end
