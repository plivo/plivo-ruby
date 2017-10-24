module Plivo
  module XML
    class GetDigits < Element
      @nestables = %w[Speak Play Wait]
      @valid_attributes = %w[action method timeout digitTimeout
                             numDigits retries invalidDigitsSound
                             validDigits playBeep redirect finishOnKey
                             digitTimeout log]

      def initialize(attributes = {}, &block)
        super(nil, attributes, &block)
      end
    end
  end
end
