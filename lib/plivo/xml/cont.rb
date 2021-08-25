module Plivo
    module XML
      class Cont < Element
        @nestables = []
        @valid_attributes = []
  
        def initialize(body)
          super(body)
        end
      end
    end
  end
  