module Plivo
  module XML
    class Emphasis < Element
      @nestables = %w(Break Emphasis Lang Phoneme Prosody SayAs Sub W)
      @valid_attributes = %w(level)

      def initialize(body, attributes = {})
        super(body, attributes)
      end
    end
  end
end
