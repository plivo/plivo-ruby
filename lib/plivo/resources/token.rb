module Plivo
  module Resources
    include Plivo
    include Plivo::Utils
    class Token < Base::Resource
      def initialize(client, options = nil)
        @_name = 'JWT/Token'
        super
        @_is_voice_request = true
      end
      def to_s
        {
          api_id: @api_id,
          token: @token
        }.to_s
      end
    end

    class TokenInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'JWT/Token'
        @_resource_type = Token
        super
        @_is_voice_request = true
      end


      def create(iss , options = nil)
        valid_param?(:iss, iss, [String, Symbol, Hash], true)
        params = {}
        params[:iss] = iss
        params[:per] = {}
        params[:per][:voice] = {}
        return perform_create(params, false) if options.nil?
        # return perform_action('Record', 'POST', nil, true) if options.nil?
        valid_param?(:options, options, [Hash], false)


        if options.key?("sub") && valid_param?("sub", options["sub"], [String, Symbol], false )
          params[:sub] = options["sub"]
        end
        if options.key("nbf") && valid_param?("nbf", options["nbf"], [Integer, Symbol], false )
          params[:nbf] = options["nbf"]
        end
        if options.key("exp") && valid_param?("exp", options["exp"], [Integer, Symbol], false )
          params[:exp] = options["exp"]
        end
        if options.key?("incoming_allow") && valid_param?("incoming_allow", options["incoming_allow"], [TrueClass, FalseClass, String,Symbol], false)
          params[:per][:voice][:incoming_allow] = options["incoming_allow"]
        end
        if options.key?("outgoing_allow") && valid_param?("outgoing_allow", options["outgoing_allow"], [TrueClass, FalseClass, String, Symbol], false)
          params[:per][:voice][:outgoing_allow] = options["outgoing_allow"]
        end
        if options.key?("app") && valid_param?("app", options["app"], [String, Symbol], false)
          params[:app] = options["app"]
        end

          perform_create(params.merge(options), false)
      end
    end
  end
end

