module Plivo
  module XML
    class Speak < Element
      @valid_attributes = %w[voice language loop]
      VALID_VOICES=[]
      def initialize(body, attributes = {})
        if attributes && attributes[:voice] && ['MAN', 'WOMAN'].include?(attributes[:voice])
          @nestables = []
        else
          @nestables = %w(Break Emphasis Lang P Phoneme Prosody S SayAs Sub W)
        end
        if !body
          raise PlivoXMLError, 'No text set for Speak'
        else
          body = HTMLEntities.new(:html4).encode(body, :decimal)
        end
        super(body, attributes, @nestables)
      end
    end
  end
end
