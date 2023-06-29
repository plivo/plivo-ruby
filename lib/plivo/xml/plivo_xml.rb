module Plivo
  module XML
    class PlivoXML
      attr_accessor :response

      def initialize(response = nil)
        response.nil? ? @response = Plivo::XML::Response.new : @response = response
      end

      def to_xml
        '<?xml version="1.0" encoding="utf-8" ?>' + @response.to_xml.gsub("&quot;", "\"")
      end

      def to_s
        '<?xml version="1.0" encoding="utf-8" ?>' + @response.to_s.gsub("&quot;", "\"")
      end
    end
  end
end
