module Plivo
  module XML
    class Response < Element
      @nestables = %w[Speak Play GetDigits GetInput Record Dial Message
                      Redirect Wait Hangup PreAnswer Conference DTMF MultiPartyCall Stream]
      @valid_attributes = []

      def initialize
        super(nil, {})
      end

      def to_xml
        super()
      end

      def to_s
        super()
      end
    end
  end
end
