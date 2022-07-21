module Plivo
    module Resources
        include Plivo::Utils

        class TokensInterface < Base::ResourceInterface
            def initialize(client, resource_list_json = nil)
                @_name = 'JWT/Token'
                @_resource_type = Tokens
                super
                @_is_voice_request = true
            end

            def create(iss,sub, options = nil)
                valid_param?(:iss,iss,[String,Symbol], true)
                valid_param?(:sub,iss,[String,Symbol], true)
                # valid_param?(:nbf,iss,[Integer,Symbol], true)
                # valid_param?(:exp,iss,[Integer,Symbol], true)
                # valid_param?(:incoming_allowed,iss,[Boolean,Symbol], true)
                # valid_param?(:outgoing_allowed,iss,[Boolean,Symbol], true)
                # valid_param?(:app,iss,[String,Symbol], true)

                if incoming_allowed == true && sub == "none"
                    raise Plivo::Exceptions::PlivoError, "sub should not be none"


                params = {
                    iss: iss,
                    sub: sub
                    # nbf: nbf,
                    # exp: exp,
                    # incoming_allowed: incoming_allowed,
                    # outgoing_allowed: outgoing_allowed,
                    # app: app
                }
                return perform_create(params, false) if options.nil?

                perform_create(params.merge(options), false)
            end
        end
    end
end


