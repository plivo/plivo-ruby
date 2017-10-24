module Plivo
  module XML
    class Hangup < Element
      @nestables = []
      @valid_attributes = %w[schedule reason]

      def initialize(attributes = {})
        super(nil, attributes)
      end
    end
  end
end
