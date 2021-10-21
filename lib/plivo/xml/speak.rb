module Plivo
  module XML
    class Speak < Element
      @valid_attributes = %w[voice language loop]

      SUPPORTED_ENGINES=%w(Polly)
      SUPPORTED_VOICES=%w(Nicole Russell Vitoria Ricardo Chantal Naja Mads Lotte Ruben Lea Celine Mathieu Vicki Marlene Hans Aditi Dora Karl Raveena Aditi Carla Giorgio Mizuki Takumi Seoyeon Zhiyu Liv Ewa Maja Jacek Jan Ines Cristiano Carmen Tatyana Maxim Conchita Enrique Astrid Filiz Amy Emma Brian Joanna Matthew Salli Justin Kendra Joey Kimberly Ivy Penelope Miguel Gwyneth Geraint Zeina Mia)

      def initialize(body, attributes = {})
        if attributes.nil? || attributes[:voice].nil? || ['MAN', 'WOMAN'].include?(attributes[:voice])
          @nestables = []
        else
          engine = attributes[:voice].split('.')[0]
          voice = attributes[:voice].split('.')[1]
          if SUPPORTED_ENGINES.include?(engine) && SUPPORTED_VOICES.include?(voice)
            @nestables = %w(Break Cont Emphasis Lang P Phoneme Prosody S SayAs Sub W)
          else
            raise PlivoXMLError, "<Speak> voice #{attributes[:voice]} is not valid."
          end
        end
        if !body
          raise PlivoXMLError, 'No text set for Speak'
        end
        super(body, attributes, @nestables)
      end
    end
  end
end
