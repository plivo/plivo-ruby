module Plivo
  module XML
    class GetInput < Element
      @nestables = %w[Speak Play Wait]
      @valid_attributes = %w[action method inputType executionTimeout
                             digitEndTimeout speechEndTimeout finishOnKey
                             numDigits speechModel hints language
                             interimSpeechResultsCallback log
                             interimSpeechResultsCallbackMethod redirect]

      def initialize(attributes = {}, &block)
        super(nil, attributes, &block)
      end
    end
  end
end
