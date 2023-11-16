module Plivo
  module Resources
    include Plivo::Utils
    class Verify < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Verify'
        @_identifier_string = 'api_id'
        super
      end
      def to_s
        {
          api_id: @api_id,
          alias: @alias,
          country: @country,
          created_at: @created_at,
          modified_at: @modified_at,
          phone_number: @phone_number,
          subaccount: @subaccount,
          verification_uuid: @verification_uuid
        }.to_s
      end
    end

      class VerifyCallerIdInterface < Base::ResourceInterface
        def initialize(client, resource_list_json = nil)
          @_name = 'VerifiedCallerId'
          @_resource_type = Verify
          @_identifier_string = 'api_id'
          super
        end

        def initiate(phone_number = nil, channel = nil, alias_ = nil)
          valid_param?(:phone_number, phone_number, [String], true)
          valid_param?(:channel, channel, [String], false)
          valid_param?(:alias, alias_, [String], false)

          params = {
            phone_number: phone_number,
            channel: channel,
            alias: alias_
          }
          perform_create(params)
        end

        def verify(verification_uuid = nil, otp = nil)
          valid_param?(:verification_uuid, verification_uuid, [String], true)
          valid_param?(:otp, otp, [String], true)
          id = 'Verification/' + verification_uuid
          params = {
            otp: otp
          }
          perform_action_with_identifier(id, 'POST', params)
        end

        def update(phone_number = nil, subaccount = nil, alias_ = nil)
          valid_param?(:phone_number, phone_number, [String], true)
          valid_param?(:subaccount, subaccount, [String], false)
          valid_param?(:alias, alias_, [String], false)
          params = {
            subaccount: subaccount,
            alias: alias_
          }
          perform_action_with_identifier(phone_number, 'POST', params)
        end

        def get(phone_number = nil)
          valid_param?(:phone_number, phone_number, [String], true)
          perform_get(phone_number)
        end

        def list(options = nil)
          return perform_list if options.nil?
          valid_param?(:options, options, Hash, true)

          params = {}
          params_expected = %i[subaccount country alias]

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

          perform_list(params)
        end

        def delete(phone_number)
          perform_delete(phone_number, nil)
        end
      end
    end
end
