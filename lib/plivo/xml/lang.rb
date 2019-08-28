module Plivo
  module XML
    class Lang < Element
      @nestables = %w(Break Emphasis Lang P Phoneme Prosody S SayAs Sub W)
      @valid_attributes = %w(xmllang)

       VALID_LANG_ATTRIBUTE_VALUES = [
        'cmn-CN','da-DK','nl-NL','en-AU','en-GB',
        'en-IN','en-US','en-GB-WLS','fr-FR',
        'fr-CA','de-DE','hi-IN','is-IS','it-IT',
        'ja-JP','ko-KR','nb-NO','pl-PL','pt-BR',
        'pt-PT','ro-RO','ru-RU','es-ES','es-MX',
        'es-US','sv-SE','tr-TR','cy-GB']


      def initialize(body, attributes = {})
        if attributes && attributes[:xmllang]
          unless VALID_LANG_ATTRIBUTE_VALUES.include?(attributes[:xmllang])
            raise PlivoXMLError, "invalid attribute value #{attributes[:xmllang]} for xmllang"
          end
          super(body, {})
          add_attribute("xml:lang", attributes[:xmllang])
        else
          raise PlivoXMLError, 'xmllang attribute is a required attribute for lang'
        end
      end
    end
  end
end
