require 'json'
require 'faraday'

module Plivo
  module Resources
    include Plivo::Utils
    class CallFeedback < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Call'
        super
      end
    end

    class CallFeedbackInterface < Base::ResourceInterface
      FEEDBACK_API_PATH = "v1/Call/%s/Feedback/"
      def initialize(client, resource_list_json = nil)
        @_name = 'Call'
        @_resource_type = CallFeedback
        super
      end

      def create(call_uuid, rating, issues = [], notes = "")
        
        valid_param?(:call_uuid, call_uuid, String, true)
        valid_param?(:rating, rating, [Integer, Float], true)

        if call_uuid == ""
          raise_invalid_request("call_uuid cannot be empty")
        end

        if rating < 1 or rating > 5
          raise_invalid_request("Rating has to be a float between 1 - 5")
        end
        
        params = {
          rating: rating,
        }

        if issues.length() > 0
          params['issues'] = issues
        end

        if notes.length > 0
          params['notes'] = notes
        end

        params['is_callinsights_request'] = true
        params['request_url'] = FEEDBACK_API_PATH % call_uuid

        return perform_post(params)
      end
    end
  end
end