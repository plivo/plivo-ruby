module Plivo
  module XML
    class Break < Element
      @nestables = []
      @valid_attributes = %w(strength time)

      def initialize(attributes = {})
        super(nil, attributes)
      end
    end
  end
end
