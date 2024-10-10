module Plivo
    module Resources
        include Plivo::Utils
        class Session < Base::Resource
            def initialize(client, options = nil)
                @_name = 'Session'
                @_identifier_string = 'session_uuid'
                super
            end
            def to_s
                {
                  api_id: @api_id,
                  session_uuid: @session_uuid,
                  app_uuid: @app_uuid,
                  alias: @alias,
                  recipient: @recipient,
                  channel: @channel,
                  locale: @locale,
                  status: @status,
                  count: @count,
                  requestor_ip: @requestor_ip,
                  destination_country_iso2: @destination_country_iso2,
                  destination_network: @destination_network,
                  attempt_details: @attempt_details,
                  charges: @charges,
                  created_at: @created_at,
                  updated_at: @updated_at
                }.to_s
            end
        end    

        class SessionInterface < Base::ResourceInterface
            def initialize(client, resource_list_json = nil)
                @_name = 'Verify/Session'
                @_resource_type = Session
                @_identifier_string = 'session_uuid'
                super
            end

            # @param [String] session_uuid
            def get(session_uuid)
                perform_get(session_uuid)
            end

            def create(app_uuid = nil, recipient = nil,channel = nil, url = nil, method = nil, locale=nil, brand_name=nil, app_hash=nil, code_length=nil, dtmf=nil)
                valid_param?(:app_uuid, app_uuid, [String, Symbol], false)
                valid_param?(:recipient, recipient, [Integer, String, Symbol], true)
                valid_param?(:channel, channel, [String, Symbol], false)
                valid_param?(:url, url, [String], false)
                valid_param?(:method, method, String, false, %w[POST GET])
                valid_param?(:locale, locale, [String, Symbol], false)
                valid_param?(:brand_name, brand_name, [String, Symbol], false)
                valid_param?(:app_hash, app_hash, [String, Symbol], false)
                valid_param?(:code_length, code_length,[Integer,Symbol], false)
                valid_param?(:dtmf, dtmf,[Integer,Symbol], false)

                params = {
                    app_uuid: app_uuid,
                    recipient: recipient,
                    channel: channel,
                    url: url,
                    method: method,
                    locale: locale,
                    brand_name: brand_name,
                    app_hash: app_hash,
                    code_length: code_length,
                    dtmf:dtmf
                }
                perform_create(params)
            end   
            
            def list(options = nil)
                return perform_list if options.nil?
                valid_param?(:options, options, Hash, true)
                params = {}
                params_expected = %i[
                subaccount status session_time__gt session_time__gte
                session_time__lt session_time__lte session_time country alias app_uuid recipient brand_name app_hash
                ]

                params_expected.each do |param|
                    if options.key?(param) &&
                       valid_param?(param, options[param], [String, Symbol], true)
                      params[param] = options[param]
                    end
                end
          
                %i[offset limit].each do |param|
                    if options.key?(param) &&
                        valid_param?(param, options[param], [Integer, Integer], true)
                        params[param] = options[param]
                    end
                end
                
                if options.key?(:limit) &&
                    (options[:limit] > 20 || options[:limit] <= 0)
                   raise_invalid_request('The maximum number of results that can be '\
                   "fetched is 20. limit can't be more than 20 or less than 1")
                end

                raise_invalid_request("Offset can't be negative") if options.key?(:offset) && options[:offset] < 0

                perform_list_without_object(params)
            end
            
            def validate(session_uuid = nil, otp = nil)
                valid_param?(:session_uuid, session_uuid, [String, Symbol], true)
                valid_param?(:otp, otp, [String], true)
                id = session_uuid
                params = {
                    otp: otp
                }
                perform_action_with_identifier(id, 'POST', params)
            end    
        end    
    end    
end    