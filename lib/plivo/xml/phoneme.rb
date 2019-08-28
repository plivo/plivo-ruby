module Plivo
  module XML
    class Phoneme < Element
      @nestables = []
      @valid_attributes = %w(alphabet ph)

      VALID_ALPHABET_ATTRIBUTE_VALUES=%w(ipa x-sampa)

      def initialize(body, attributes = {})
        unless attributes && attributes[:ph]
          raise PlivoXMLError, 'ph attribute is required for Phoneme'
        end
        if attributes && attributes[:alphabet] && !VALID_ALPHABET_ATTRIBUTE_VALUES.include?(attributes[:alphabet])
          raise PlivoXMLError, "invalid attribute value #{attributes[:alphabet]} for alphabet"
        end
        super(body, attributes)
      end
    end
  end
end
