module Plivo
  module XML
    class SayAs < Element
      @nestables = []
      @valid_attributes = %w(interpret-as format)

      VALID_INTERPRET_AS_ATTRIBUTE_VALUES=%w(character spell-out cardinal number ordinal digits fraction unit date time address expletive telephone)
      VALID_FORMAT_ATTRIBUTE_VALUES=%w(mdy dmy ymd md dm ym my d m y yyyymmdd)

      def initialize(body, attributes = {})
        unless attributes && attributes["interpret-as"]
          raise PlivoXMLError, 'interpret-as is a required attribute for say-as element'
        end
        if !VALID_INTERPRET_AS_ATTRIBUTE_VALUES.include?(attributes["interpret-as"])
          raise PlivoXMLError, "invalid attribute value #{attributes["interpret-as"]} for interpret-as"
        end
        if attributes["interpret-as"]=='date' && attributes[:format] && !VALID_FORMAT_ATTRIBUTE_VALUES.include?(attributes[:format])
          raise PlivoXMLError, "invalid attribute value #{attributes[:format]} for format"
        end
        super(body, attributes)
      end
    end
  end
end
