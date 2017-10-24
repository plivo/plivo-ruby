module Plivo
  module XML
    class PreAnswer < Element
      @nestables = %w[Play Speak GetDigits Wait Redirect Message DTMF]
      @valid_attributes = []

      def initialize(attributes = {}, &block)
        super(nil, attributes, &block)
      end
    end
  end
end
