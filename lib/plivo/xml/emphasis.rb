module Plivo
  module XML
    class Emphasis < Element
      @nestables = %w(Break Cont Emphasis Lang Phoneme Prosody SayAs Sub W)
      @valid_attributes = %w(level)

      VALID_LEVEL_ATTRIBUTE_VALUE=%w(strong moderate reduced)

      def initialize(body, attributes = {})
        if attributes && attributes[:level] && !VALID_LEVEL_ATTRIBUTE_VALUE.include?(attributes[:level])
          raise PlivoXMLError, "invalid attribute value #{attributes[:level]} for level"
        end
        super(body, attributes)
      end
    end
  end
end
