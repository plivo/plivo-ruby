module Plivo
  module XML
    class Wait < Element
      @nestables = []
      @valid_attributes = %w[length silence minSilence beep]

      def initialize(attributes = {})
        super(nil, attributes)
      end
    end
  end
end
