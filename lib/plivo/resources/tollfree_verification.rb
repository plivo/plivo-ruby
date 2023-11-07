module Plivo
  module Resources
    include Plivo::Utils

    class TollfreeVerification < Base::Resource
      def initialize(client, options = nil)
        @_name = 'TollfreeVerification'
        @_identifier_string = 'tollfree_verification'
        super
      end

      def update(options = nil)
        return perform_update({}) if options.nil?

        valid_param?(:options, options, Hash, true)

        params = {}
        params_expected = %i[ usecase usecase_summary profile_uuid optin_type optin_image_url volume message_sample callback_method callback_url extra_data additional_information ]
        params_expected.each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], false)
            params[param] = options[param]
          end
        end

        perform_update(params)
      end

      def delete
        perform_delete
      end

      def to_s
        {
          api_id: @api_id,
          uuid: @uuid,
          number: @number,
          created_at: @created_at,
          updated_at: @updated_at,
          callback_method: @callback_url,
          callback_url: @callback_url,
          extra_data: @extra_data,
          additional_information: @additional_information,
          message_sample: @message_sample,
          optin_image_url: @optin_image_url,
          optin_type: @optin_type,
          profile_uuid: @profile_uuid,
          rejection_reason: @rejection_reason,
          status: @status,
          usecase: @usecase,
          usecase_summary: @usecase_summary,
          volume: @volume
        }.delete_if { |key, value| value.nil? }.to_s
      end
    end

    class TollfreeVerificationsInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'TollfreeVerification'
        @_resource_type = TollfreeVerification
        @_identifier_string = 'tollfree_verification'
        super
      end

      ##
      # Get an TollfreeVerification
      # @param [String] uuid
      # return [TollfreeVerification]
      def get(uuid)
        valid_param?(:uuid, uuid, [String, Symbol], true)
        perform_get(uuid)
      end

      ##
      # List all TollfreeVerification
      # @param [Hash] options
      # @option options [Int] :offset
      # @option options [Int] :limit
      # @return [Hash]
      def list(options = nil)
        return perform_list if options.nil?
        valid_param?(:options, options, Hash, true)

        params = {}
        params_expected = %i[ profile_uuid number status created_lt created_gt usecase ]
        params_expected.each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end

        %i[offset limit].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                 [Integer], true)
            params[param] = options[param]
          end
        end

        raise_invalid_request("Offset can't be negative") if options.key?(:offset) && options[:offset] < 0

        if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
          raise_invalid_request('The maximum number of results that can be '\
          "fetched is 20. limit can't be more than 20 or less than 1")
        end

        perform_list(params)
      end

      ##
      # Create an TollfreeVerification
      # @param [String] number
      # @param [String] usecase
      # @param [String] usecase_summary
      # @param [String] profile_uuid
      # @param [String] optin_type
      # @param [String] optin_image_url
      # @param [String] volume
      # @param [String] message_sample
      # @param [String] callback_url
      # @param [String] callback_method
      # @param [String] extra_data
      # @param [String] additional_information
      # return [TollfreeVerification] TollfreeVerification
      def create(number, usecase, usecase_summary, profile_uuid, optin_type, optin_image_url, volume, message_sample, callback_url = nil, callback_method = nil, extra_data = nil, additional_information = nil)
        valid_param?(:number, number, [String, Symbol], true)
        valid_param?(:usecase, usecase, [String, Symbol], true)
        valid_param?(:usecase_summary, usecase_summary, [String, Symbol], true)
        valid_param?(:profile_uuid, profile_uuid, [String, Symbol], true)
        valid_param?(:optin_type, optin_type, [String, Symbol], true)
        valid_param?(:optin_image_url, optin_image_url, [String, Symbol], true)
        valid_param?(:volume, volume, [String, Symbol], true)
        valid_param?(:message_sample, message_sample, [String, Symbol], true)
        valid_param?(:callback_url, callback_url, [String, Symbol], false)
        valid_param?(:callback_method, callback_method, [String, Symbol], false)
        valid_param?(:extra_data, extra_data, [String, Symbol], false)
        valid_param?(:additional_information, additional_information, [String, Symbol], false)

        params = {
        number: number,
        usecase: usecase,
        usecase_summary: usecase_summary,
        profile_uuid: profile_uuid,
        optin_type: optin_type,
        optin_image_url: optin_image_url,
        volume: volume,
        message_sample: message_sample,
        callback_url: callback_url,
        callback_method: callback_method,
        extra_data: extra_data,
        additional_information: additional_information
        }.delete_if { |key, value| value.nil? }

        return perform_create(params)
      end

      ##
      # Update an TollfreeVerification
      # @param [String] uuid
      # @param [Hash] options
      # return [TollfreeVerification]
      def update(uuid, options = nil)
        valid_param?(:uuid, uuid, [String, Symbol], true)
        TollfreeVerification.new(@_client,
                        resource_id: uuid).update(options)
      end

      ##
      # Delete an TollfreeVerification.
      # @param [String] uuid
      def delete(uuid)
        valid_param?(:uuid, uuid, [String, Symbol], true)
        TollfreeVerification.new(@_client,
                        resource_id: uuid).delete
      end
    end
  end
end