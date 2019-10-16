module Plivo
  module XML
    class S < Element
      @nestables = %w(Break Emphasis Lang Phoneme Prosody SayAs Sub W)
      @valid_attributes = []

      def initialize(body)
        super(body)
      end
    end
  end
end
