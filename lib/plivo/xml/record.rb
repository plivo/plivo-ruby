module Plivo
  module XML
    class Record < Element
      @nestables = []
      @valid_attributes = %w[action method timeout finishOnKey
                             maxLength playBeep recordSession
                             startOnDialAnswer redirect fileFormat
                             callbackUrl callbackMethod
                             transcriptionType transcriptionUrl
                             transcriptionMethod]

      def initialize(attributes = {})
        super(nil, attributes)
      end
    end
  end
end
