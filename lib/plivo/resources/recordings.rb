module Plivo
  module Resources
    include Plivo::Utils
    class Recording < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Recording'
        @_identifier_string = 'recording_id'
        super
        @_is_voice_request = true
      end

      def delete
        perform_delete
      end

      def to_s
        {
          add_time: @add_time,
          api_id: @api_id,
          call_uuid: @call_uuid,
          conference_name: @conference_name,
          monthly_recording_storage_amount: @monthly_recording_storage_amount,
          recording_storage_duration: @recording_storage_duration,
          recording_duration_ms: @recording_duration_ms,
          recording_end_ms: @recording_end_ms,
          recording_format: @recording_format,
          recording_id: @recording_id,
          recording_start_ms: @recording_start_ms,
          recording_type: @recording_type,
          recording_url: @recording_url,
          resource_uri: @resource_uri,
          rounded_recording_duration: @rounded_recording_duration,
          recording_storage_rate: @recording_storage_rate,
          from_number: @from_number,
          to_number: @to_number,
          mpc_name: @mpc_name,
          conference_uuid: @conference_uuid,
          mpc_uuid: @mpc_uuid
        }.to_s
      end
    end

    class RecordingInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Recording'
        @_resource_type = Recording
        @_identifier_string = 'recording_id'
        super
        @_is_voice_request = true
      end

      # @param [Hash] options
      # @option options [String] :subaccount auth_id of the subaccount. Lists only those recordings of the main accounts which are tied to the specified subaccount.
      # @option options [String] :call_uuid Used to filter recordings for a specific call.
      # @option options [String] :from_number Used to filter recordings for a specific from_number.
      # @option options [String] :to_number Used to filter recordings for a specific to_number.
      # @option options [String] :conference_name Used to filter recordings for a specific conference_name.
      # @option options [String] :mpc_name Used to filter recordings for a specific mpc_name.
      # @option options [String] :conference_uuid Used to filter recordings for a specific conference_uuid.
      # @option options [String] :mpc_uuid Used to filter recordings for a specific mpc_uuid.
      # @option options [String] :add_time Used to filter out recordings according to the time they were added.The add_time filter is a comparative filter that can be used in the following four forms:
      #                                    - add_time\__gt: gt stands for greater than. The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. Eg:- To get all recordings that started after 2012-03-21 11:47, use add_time\__gt=2012-03-21 11:47
      #                                    - add_time\__gte: gte stands for greater than or equal. The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. Eg:- To get all recordings that started after or exactly at 2012-03-21 11:47[:30], use add_time\__gte=2012-03-21 11:47[:30]
      #                                    - add_time\__lt: lt stands for lesser than. The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. Eg:- To get all recordings that started before 2012-03-21 11:47, use add_time\__lt=2012-03-21 11:47
      #                                    - add_time\__gte: lte stands for lesser than or equal. The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. Eg:- To get all recordings that started before or exactly at 2012-03-21 11:47[:30], use add_time\__lte=2012-03-21 11:47[:30]
      #                                    - Note: The above filters can be combined to get recordings that started in a particular time range.
      # @option options [Int] :recording_storage_duration - Used to filter out recordings according to the number of days they have been stored in the DB.The recording_storage_duration filter can be used in the following five forms:
      #                                    - recording_storage_duration: Takes an integer input and returns the recordings which are as old as that value.
      #                                    - recording_storage_duration\__gt: gt stands for greater than. The format expected is an integer value. Eg:- To get all recordings that are older than 100 days, use recording_storage_duration\__gt=100
      #                                    - recording_storage_duration\__gte: gte stands for greater than or equal. The format expected is an integer value. Eg:- To get all recordings that are older than or equal to 100 days old, use recording_storage_duration\__gte=100
      #                                    - recording_storage_duration\__lt: lt stands for lesser than. The format expected is an integer value. Eg:- To get all recordings that are newer than 100 days, use recording_storage_duration\__lt=100
      #                                    - recording_storage_duration\__lte: lte stands for lesser than or equal. The format expected is an integer value. Eg:- To get all recordings that are newer than or equal to 100 days old, use recording_storage_duration\__lte=100
      #                                    - Note: The above filters can be combined to get recordings that started in a particular time range.
      # @option options [Int] :limit Used to display the number of results per page. The maximum number of results that can be fetched is 20.
      # @option options [Int] :offset Denotes the number of value items by which the results should be offset. Eg:- If the result contains a 1000 values and limit is set to 10 and offset is set to 705, then values 706 through 715 are displayed in the results. This parameter is also used for pagination of the results.
      def list(options = nil)
        return perform_list if options.nil?
        valid_param?(:options, options, Hash, true)

        params = {}
        params_expected = %i[
          call_uuid add_time__gt add_time__gte
          add_time__lt add_time__lte
          from_number to_number conference_uuid
          conference_name mpc_name mpc_uuid
          recording_storage_duration
          recording_storage_duration__gt recording_storage_duration__gte
          recording_storage_duration__lt recording_storage_duration__lte
        ]

        params_expected.each do |param|
          if options.key?(param) && valid_param?(param, options[param], [String, Symbol, Integer], true)
            params[param] = options[param]
          end
        end

        if options.key?(:subaccount) &&
           valid_subaccount?(options[:subaccount], true)
          params[:subaccount] = options[:subaccount]
        end

        %i[offset limit].each do |param|
          if options.key?(param) && valid_param?(param, options[param], [Integer, Integer], true)
            params[param] = options[param]
          end
        end

        if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
          raise_invalid_request('The maximum number of results that can be fetched'\
          " is 20. limit can't be more than 20 or less than 1")
        end

        raise_invalid_request("Offset can't be negative") if options.key?(:offset) && options[:offset] < 0

        perform_list(params)
      end

      # @param [String] recording_id
      def get(recording_id)
        valid_param?(:recording_id, recording_id, [String, Symbol], true)
        raise_invalid_request('Invalid recording_id passed') if recording_id.empty?
        perform_get(recording_id)
      end

      def each
        offset = 0
        loop do
          recording_list = list(offset: offset)
          recording_list[:objects].each { |recording| yield recording }
          offset += 20
          return unless recording_list.length == 20
        end
      end

      # @param [String] recording_id
      def delete(recording_id)
        valid_param?(:recording_id, recording_id, [String, Symbol], true)
        raise_invalid_request('Invalid recording_id passed') if recording_id.empty?
        Recording.new(@_client, resource_id: recording_id).delete
      end
    end
  end
end
