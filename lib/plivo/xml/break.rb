module Plivo
  module XML
    class Break < Element
      @nestables = []
      @valid_attributes = %w(strength time)
      VALID_STRENGTH_VALUES= %w(none x-weak weak medium strong x-strong)

      def initialize(attributes = {})
        if attributes && attributes[:strength] && !VALID_STRENGTH_VALUES.include?(attributes[:strength])
          raise PlivoXMLError, "invalid attribute value #{attributes[:strength]} for strength"
        end
        if attributes && attributes[:time]
          if attributes[:time].downcase().include?('ms')
            time = attributes[:time].split('ms')[0].to_i
            if  time<= 0 || time >10000
              raise PlivoXMLError, "invalid attribute value #{attributes[:time]} for time attribute. Value for time in milliseconds should be > 0 or < 10000"
            end
          elsif attributes[:time].downcase().include?('s')
            time = attributes[:time].split('s')[0].to_i
            if  time<= 0 || time >10
              raise PlivoXMLError, "invalid attribute value #{attributes[:time]} for time attribute. Value for time in seconds should be > 0 or < 10"
            end
          else
            raise PlivoXMLError, "invalid attribute value #{attributes[:time]} for time attribute"
          end
        end
        super(nil, attributes)
      end
    end
  end
end
