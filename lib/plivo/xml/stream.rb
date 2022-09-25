module Plivo
  module XML
    class Stream < Element
      @nestables = []
      @valid_attributes = %w[bidirectional audioTrack streamTimeout statusCallbackUrl
                             statusCallbackMethod contentType extraHeaders]

      SUPPORTED_BIDIRECTIONAL=%w(true false)
      SUPPORTED_AUDIOTRACK=%w(inbound outbound both)
      SUPPORTED_CALLBACKMETHOD=%w(GET POST)

      def initialize(body, attributes = {})
        if attributes && attributes[:extraHeaders]
          input = attributes[:extraHeaders]
          headers = Hash.new
          input.each do |keys, value|
            if keys.to_s.end_with?("X-PH")
              headers[keys.to_s] = value
            else
              headers[keys.to_s + "X-PH"] = value
            end
          end
          headersString = headers.to_json
          puts headersString
          attributes[:extraHeaders] = headersString
        end
        if attributes[:bidirectional] && !SUPPORTED_BIDIRECTIONAL.include?(attributes[:bidirectional])
          raise PlivoXMLError, "<Stream> bidirectional #{attributes[:bidirectional]} is not valid."
        end
        if attributes[:audioTrack] && !SUPPORTED_AUDIOTRACK.include?(attributes[:audioTrack])
          raise PlivoXMLError, "<Stream> audioTrack #{attributes[:audioTrack]} is not valid."
        end
        if attributes[:statusCallbackMethod] && !SUPPORTED_CALLBACKMETHOD.include?(attributes[:statusCallbackMethod].upcase)
          raise PlivoXMLError, "<Stream> statusCallbackMethod #{attributes[:statusCallbackMethod]} is not valid."
        end
        raise PlivoXMLError, 'No text set for Stream' unless body
        super(body, attributes)
      end
    end
  end
end