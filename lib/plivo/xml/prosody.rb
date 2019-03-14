module Plivo
  module XML
    class Prosody < Element
      @nestables = %w(Break Emphasis Lang P Phoneme Prosody S SayAs Sub W)
      @valid_attributes = %w(volume rate pitch)

      def initialize(body, attributes = {})
        if attributes.nil? || attributes.length == 0
          raise PlivoXMLError, 'Specify at least one attribute for Prosody tag'
        end
        super(body, attributes)
      end
    end
  end
end
