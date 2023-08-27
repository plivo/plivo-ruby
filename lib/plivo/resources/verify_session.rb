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

            def create(app_uuid = nil, recipient = nil,channel = nil,url = nil, method = nil)
                value = app_uuid
                if(value.is_a?(Hash))
                    valid_param?(:app_uuid, value[:app_uuid], [String, Symbol], false)
                    valid_param?(:recipient, value[:recipient], [Integer, String, Symbol], true)
                    valid_param?(:channel, value[:channel], [String, Symbol], false)
                    valid_param?(:url, value[:url], [String], false)
                    valid_param?(:method, value[:method], String, false, %w[POST GET])

                    params = {
                        app_uuid: value[:app_uuid],
                        recipient: value[:recipient],
                        channel: value[:channel],
                        url: value[:url],
                        method: value[:method]
                    }

                else
                    valid_param?(:app_uuid, app_uuid, [String, Symbol], false)
                    valid_param?(:recipient, recipient, [Integer, String, Symbol], true)
                    valid_param?(:channel, channel, [String, Symbol], false)
                    valid_param?(:url, url, [String], false)
                    valid_param?(:method, method, String, false, %w[POST GET])

                    params = {
                        app_uuid: app_uuid,
                        recipient: recipient,
                        channel: channel,
                        url: url,
                        method: method
                    }
                    
                end    
                perform_create(params)    
            end   
            
            def list(options = nil)
                return perform_list if options.nil?
                valid_param?(:options, options, Hash, true)
                params = {}
                params_expected = %i[
                subaccount status session_time__gt session_time__gte
                session_time__lt session_time__lte session_time country alias app_uuid recipient
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
                value = session_uuid
                id = ""
                if(value.is_a?(Hash))
                    valid_param?(:session_uuid, value[:session_uuid], [String, Symbol], true)
                    valid_param?(:otp, value[:otp], [String], true)  
                    id = value[:session_uuid]
                    params = {
                        otp: value[:otp]
                    }
                else
                    valid_param?(:session_uuid, session_uuid, [String, Symbol], true)
                    valid_param?(:otp, otp, [String], true)  
                    id = session_uuid
                    params = {
                        otp: otp
                    }
                end  
                perform_create_with_id(id,params)      
            end    
        end    
    end    
end    