module Plivo
  module XML
    class P < Element
      @nestables = %w(Break Emphasis Lang Phoneme Prosody SayAs Sub S W)
      @valid_attributes = []

      def initialize(body)
        super(body)
      end
    end
  end
end
