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

      def create(iss, options = nil)
        # def create(iss, sub = nil, nbf = nil, exp = nil, incoming_allowed = nil, outgoing_allowed = nil, app = nil, options = nil)
        #   valid_param?(:iss, iss, [String, Symbol], true)
        #   valid_param?(:sub, sub, [String, Symbol], false)
        #   valid_param?(:nbf, nbf, [Integer,String], false)
        #   valid_param?(:exp, exp, [Integer,String], false)
        #   valid_param?(:incoming_allowed, incoming_allowed, [TrueClass, FalseClass],
        #                false, [true, false])
        #   valid_param?(:outgoing_allowed, outgoing_allowed,  [TrueClass, FalseClass],
        #                false, [true, false])
        # valid_param?(:app, app, [String, Symbol], false)


        params = {
          iss: iss,
          # sub: sub,
          # nbf: nbf,
          # exp: exp,
          # incoming_allowed: incoming_allowed,
          # outgoing_allowed: outgoing_allowed
          # app: app
        }

        return perform_create(params, false) if options.nil?

        perform_create(params.merge(options), false)
      end
    end
  end
end

