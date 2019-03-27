module Plivo
  module XML
    class Prosody < Element
      @nestables = %w(Break Emphasis Lang P Phoneme Prosody S SayAs Sub W)
      @valid_attributes = %w(volume rate pitch)

      VALID_VOLUME_ATTRIBUTE_VALUES=%w(default silent x-soft soft medium loud x-loud)
      VALID_RATE_ATTRIBUTE_VALUES=%w(x-slow slow medium fast x-fast)
      VALID_PITCH_ATTRIBUTE_VALUES=%w(default x-low low medium high x-high)

      def initialize(body, attributes = {})
        if attributes.nil? || attributes.length == 0
          raise PlivoXMLError, 'Specify at least one attribute for Prosody tag'
        end
        if attributes[:volume] && !VALID_VOLUME_ATTRIBUTE_VALUES.include?(attributes[:volume]) && !attributes[:volume].include?('dB')
          raise PlivoXMLError, "invalid attribute value #{attributes[:volume]} for volume"
        end
        if attributes[:rate] && !VALID_RATE_ATTRIBUTE_VALUES.include?(attributes[:rate]) && (!attributes[:rate].include?('%') || attributes[:rate].split('%')[0].to_i < 0)
          raise PlivoXMLError, "invalid attribute value #{attributes[:rate]} for rate"
        end
        if attributes[:pitch] && !VALID_PITCH_ATTRIBUTE_VALUES.include?(attributes[:pitch]) && !attributes[:pitch].include?('%')
          raise PlivoXMLError, "invalid attribute value #{attributes[:pitch]} for pitch"
        end
        super(body, attributes)
      end
    end
  end
end
