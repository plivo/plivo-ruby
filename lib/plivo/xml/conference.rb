module Plivo
  module XML
    class Conference < Element
      @nestables = []
      @valid_attributes = %w[muted beep startConferenceOnEnter
                             endConferenceOnExit waitSound enterSound exitSound
                             timeLimit hangupOnStar maxMembers
                             record recordFileFormat action method redirect
                             digitsMatch callbackUrl callbackMethod
                             stayAlone floorEvent
                             transcriptionType transcriptionUrl
                             transcriptionMethod recordWhenAlone relayDTMF]

      def initialize(body, attributes = {})
        raise PlivoXMLError, 'No conference name set for Conference' unless body
        super(body, attributes)
      end
    end
  end
end
