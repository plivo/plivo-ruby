module Plivo
  module Resources
    include Plivo
    include Plivo::Utils
    class Token < Base::Resource
      def initialize(client, options = nil)
        @_name = 'JWT/Token'
        @_identifier_string = 'tokens_id'
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
        @_identifier_string = 'token_id'
        super
        @_is_voice_request = true
      end


      def create(iss ,sub = nil ,nbf = nil ,exp = nil ,incoming_allow = nil ,outgoing_allow = nil ,app = nil , options = nil)
          valid_param?(:iss, iss, [String, Symbol], true)
          valid_param?(:sub, sub, [String, Symbol], false)
          valid_param?(:nbf, nbf, [Integer,String], false)
          valid_param?(:exp, exp, [Integer,String], false)
          valid_param?(:incoming_allow, incoming_allow, [TrueClass, FalseClass],
                       false, [true, false])
          valid_param?(:outgoing_allow, outgoing_allow,  [TrueClass, FalseClass],
                       false, [true, false])
          valid_param?(:app, app, [String, Symbol], false)



          if incoming_allow == true && sub.nil?
            raise Plivo::Exceptions::ValidationError, "sub is required when incoming_allow is true"
          elsif iss.nil?
            raise Plivo::Exceptions::ValidationError, "iss is required"
          else
            params = {}
            params[:iss] = iss if iss
            params[:sub] = sub if sub
            params[:nbf] = nbf if nbf
            params[:exp] = exp if exp
            params[:per] = {}
            params[:per][:voice] = {}
            params[:per][:voice][:incoming_allow] = incoming_allow if incoming_allow
            params[:per][:voice][:outgoing_allow] = outgoing_allow if outgoing_allow
            params[:app] = app if app

            return perform_create(params, false) if options.nil?

            perform_create(params.merge(options), false)
            end
      end
    end
  end
end

