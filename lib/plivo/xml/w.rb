module Plivo
  module XML
    class W < Element
      @nestables = %w(Break Cont Emphasis Phoneme Prosody SayAs Sub)
      @valid_attributes = %w(role)

      VALID_ROLE_ATTRIBUTE_VALUES=%w(amazon:VB amazon:VBD amazon:SENSE_1)

      def initialize(body, attributes = {})
        if attributes && attributes[:role] && !VALID_ROLE_ATTRIBUTE_VALUES.include?(attributes[:role])
          raise PlivoXMLError, "invalid attribute value #{attributes[:role]} for role"
        end
        super(body, attributes)
      end
    end
  end
end
