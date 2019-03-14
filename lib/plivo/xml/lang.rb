module Plivo
  module XML
    class Lang < Element
      @nestables = %w(Break Emphasis Lang P Phoneme Prosody S SayAs Sub W)
      @valid_attributes = %w(xmllang)

      def initialize(body, attributes = {})
        if attributes && attributes[:xmllang]
          super(body, {})
          add_attribute("xml:lang", attributes[:xmllang])
        else
          raise PlivoXMLError, 'xmllang attribute is a required attribute for lang'
        end
      end
    end
  end
end
