module Plivo
    module XML
      class Cont < Element
        @nestables = %w(Break Emphasis Lang P Phoneme Prosody S SayAs Sub W)
        @valid_attributes = []
  
        def initialize(body)
          super(body)
        end
      end
    end
  end
  