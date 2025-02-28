module Plivo
  module Resources
    include Plivo::Utils
    class MaskingSession < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Masking/Session'
        @_identifier_string = 'session_uuid'
        super
        @_is_voice_request = true
      end

      def update(options = nil)
        return if options.nil?
        valid_param?(:options, options, Hash, true)

        params = {}
        params_expected = %i[first_party second_party session_expiry call_time_limit record record_file_format recording_callback_url
                      callback_url callback_method ring_timeout first_party_play_url second_party_play_url recording_callback_method
                      subaccount geomatch]
        params_expected.each do |param|
          if options.key?(param) && valid_param?(param, options[param], [String, Symbol, TrueClass, FalseClass], true)
            params[param] = options[param]
          end
        end

        updated_session = perform_masking_update(params)
        session_data = updated_session.instance_variables.map do |var|
          [var[1..-1].to_sym, updated_session.instance_variable_get(var)]
        end.to_h

        relevant_keys = %i[api_id message session]
        filtered_session_data = session_data.select { |key, _| relevant_keys.include?(key) }

        if filtered_session_data[:session]
          session_instance = filtered_session_data[:session]
          session_data = session_instance.map do |key, value|
            [key.to_sym, value]
          end.to_h

          # Extract relevant keys from session
          session_relevant_keys = %i[first_party second_party virtual_number status initiate_call_to_first_party session_uuid callback_url callback_method created_time
                               modified_time expiry_time duration amount call_time_limit ring_timeout first_party_play_url second_party_play_url record record_file_format recording_callback_url
                               recording_callback_method interaction total_call_amount total_call_count total_call_billed_duration total_session_amount last_interaction_time unknown_caller_play
                               is_pin_authentication_required generate_pin generate_pin_length first_party_pin second_party_pin pin_prompt_play pin_retry pin_retry_wait incorrect_pin_play]

          filtered_session_data[:session] = session_data.select { |key, _| session_relevant_keys.include?(key) }
        end

        filtered_session_data
      end

      def delete
        perform_delete
      end

      def to_s
        {
          first_party: @first_party,
          second_party: @second_party,
          virtual_number: @virtual_number,
          status: @status,
          initiate_call_to_first_party: @initiate_call_to_first_party,
          session_uuid: @session_uuid,
          callback_url: @callback_url,
          callback_method: @callback_method,
          created_time: @created_time,
          modified_time: @modified_time,
          expiry_time: @expiry_time,
          duration: @duration,
          amount: @amount,
          call_time_limit: @call_time_limit,
          ring_timeout: @ring_timeout,
          first_party_play_url: @first_party_play_url,
          second_party_play_url: @second_party_play_url,
          record: @record,
          record_file_format: @record_file_format,
          recording_callback_url: @recording_callback_url,
          recording_callback_method: @recording_callback_method,
          interaction: @interaction,
          total_call_amount: @total_call_amount,
          total_call_count: @total_call_count,
          total_call_billed_duration: @total_call_billed_duration,
          total_session_amount: @total_session_amount,
          last_interaction_time: @last_interaction_time,
          is_pin_authentication_required: @is_pin_authentication_required,
          generate_pin: @generate_pin,
          generate_pin_length: @generate_pin_length,
          second_party_pin: @second_party_pin,
          pin_prompt_play: @pin_prompt_play,
          pin_retry: @pin_retry,
          pin_retry_wait: @pin_retry_wait,
          incorrect_pin_play: @incorrect_pin_play,
          unknown_caller_play: @unknown_caller_play,
          force_pin_authentication: @force_pin_authentication,
          virtual_number_cooloff_period: @virtual_number_cooloff_period,
          create_session_with_single_party: @create_session_with_single_party
        }.to_s
      end
    end

    class MaskingSessionInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Masking/Session'
        @_resource_type = MaskingSession
        @_identifier_string = 'session_uuid'
        super
        @_is_voice_request = true
      end

      def get(session_uuid)
        valid_param?(:session_uuid, session_uuid, [String, Symbol], true)
        perform_get_with_response(session_uuid)
      end

      def create(first_party: nil, second_party: nil, session_expiry: nil, call_time_limit: nil, record: nil, record_file_format: nil,
                 recording_callback_url: nil, initiate_call_to_first_party: nil, callback_url: nil, callback_method: nil, ring_timeout: nil,
                 first_party_play_url: nil, second_party_play_url: nil, recording_callback_method: nil, is_pin_authentication_required: nil,
                 generate_pin: nil, generate_pin_length: nil, first_party_pin: nil, second_party_pin: nil, pin_prompt_play: nil, pin_retry: nil,
                 pin_retry_wait: nil, incorrect_pin_play: nil, unknown_caller_play: nil, subaccount: nil, geomatch: nil, force_pin_authentication: nil, virtual_number_cooloff_period: nil, create_session_with_single_party: nil)

        valid_param?(:first_party, first_party, [String, Symbol], false)
        valid_param?(:second_party, second_party, [String, Symbol], false)

        params = {}
        params[:first_party] = first_party unless first_party.nil?
        params[:second_party] = second_party  unless second_party.nil?
        params[:session_expiry] = session_expiry unless session_expiry.nil?
        params[:call_time_limit] = call_time_limit unless call_time_limit.nil?
        params[:record] = record unless record.nil?
        params[:record_file_format] = record_file_format unless record_file_format.nil?
        params[:recording_callback_url] = recording_callback_url unless recording_callback_url.nil?
        params[:initiate_call_to_first_party] = initiate_call_to_first_party unless initiate_call_to_first_party.nil?
        params[:callback_url] = callback_url unless callback_url.nil?
        params[:callback_method] = callback_method unless callback_method.nil?
        params[:ring_timeout] = ring_timeout unless ring_timeout.nil?
        params[:first_party_play_url] = first_party_play_url unless first_party_play_url.nil?
        params[:second_party_play_url] = second_party_play_url unless second_party_play_url.nil?
        params[:recording_callback_method] = recording_callback_method unless recording_callback_method.nil?
        params[:is_pin_authentication_required] = is_pin_authentication_required unless is_pin_authentication_required.nil?
        params[:generate_pin] = generate_pin unless generate_pin.nil?
        params[:generate_pin_length] = generate_pin_length unless generate_pin_length.nil?
        params[:first_party_pin] = first_party_pin unless first_party_pin.nil?
        params[:second_party_pin] = second_party_pin unless second_party_pin.nil?
        params[:pin_prompt_play] = pin_prompt_play unless pin_prompt_play.nil?
        params[:pin_retry] = pin_retry unless pin_retry.nil?
        params[:pin_retry_wait] = pin_retry_wait unless pin_retry_wait.nil?
        params[:incorrect_pin_play] = incorrect_pin_play unless incorrect_pin_play.nil?
        params[:unknown_caller_play] = unknown_caller_play unless unknown_caller_play.nil?
        params[:subaccount] = subaccount unless subaccount.nil?
        params[:geomatch] = geomatch unless geomatch.nil?
        params[:force_pin_authentication] = force_pin_authentication unless force_pin_authentication.nil?
        params[:virtual_number_cooloff_period] = virtual_number_cooloff_period unless virtual_number_cooloff_period.nil?
        params[:create_session_with_single_party] = create_session_with_single_party unless create_session_with_single_party.nil?
        perform_create(params)
      end

      def list(options = nil)
        return perform_list_with_response if options.nil?
        valid_param?(:options, options, Hash, true)

        raise_invalid_request("Offset can't be negative") if options.key?(:offset) && options[:offset] < 0

        if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
          raise_invalid_request('The maximum number of results that can be '\
                                  "fetched is 20. limit can't be more than 20 or less than 1")
        end

        params = %i[
          first_party
          second_party
          virtual_number
          status
          created_time
          created_time__lt
          created_time__gt
          created_time__lte
          created_time__gte
          expiry_time
          expiry_time__lt
          expiry_time__gt
          expiry_time__lte
          expiry_time__gte
          duration
          duration__lt
          duration__gt
          duration__lte
          duration__gte
          limit
          offset
          subaccount
        ].reduce({}) do |result_hash, param|
          if options.key?(param)
            if valid_param?(param, options[param], [String, Symbol], true)
              result_hash[param] = options[param]
            end
          end
          result_hash
        end

        perform_list_with_response(params)
      end

      def each
        maskingsession_list = list
        maskingsession_list[:objects].each { |maskingsession| yield maskingsession }
      end

      def update(session_uuid, options = nil)
        valid_param?(:session_uuid, session_uuid, [String, Symbol], true)
        MaskingSession.new(@_client, resource_id: session_uuid).update(options)
      end

      def delete(session_uuid)
        valid_param?(:session_uuid, session_uuid, [String, Symbol], true)
        MaskingSession.new(@_client, resource_id: session_uuid).delete
      end
    end
  end
end
