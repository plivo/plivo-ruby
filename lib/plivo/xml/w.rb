module Plivo
  module XML
    class W < Element
      @nestables = %w(Break Emphasis Phoneme Prosody SayAs Sub)
      @valid_attributes = %w(role)

      def initialize(body, attributes = {})
        super(body, attributes)
      end
    end
  end
end
