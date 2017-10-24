module Plivo
  module XML
    class Dial < Element
      @nestables = %w[Number User]
      @valid_attributes = %w[action method timeout hangupOnStar
                             timeLimit callerId callerName confirmSound
                             dialMusic confirmKey redirect
                             callbackUrl callbackMethod digitsMatch digitsMatchBLeg
                             sipHeaders]

      def initialize(attributes = {}, &block)
        super(nil, attributes, &block)
      end
    end
  end
end
