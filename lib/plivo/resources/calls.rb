module Plivo
  module Resources
    include Plivo::Utils
    class Call < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Call'
        @_identifier_string = 'call_uuid'
        super
        @_is_voice_request = true
      end

      def update(options)
        valid_param?(:options, options, Hash, true)

        params = {}

        if options.key?(:legs) &&
           valid_param?(:legs, options[:legs],
                        [String, Symbol], true, %w[aleg bleg both])
          params[:legs] = options[:legs]
        end

        unless options.key?(:legs)
          unless options.key?(:aleg_url)
            raise_invalid_request('default leg is aleg, aleg_url has to be specified')
          end
          params[:aleg_url] = options[:aleg_url]
        end

        if options[:legs] == 'aleg'
          unless options.key?(:aleg_url)
            raise_invalid_request('leg is aleg, aleg_url has to be specified')
          end
          params[:aleg_url] = options[:aleg_url]
        end

        if options[:legs] == 'bleg'
          unless options.key?(:bleg_url)
            raise_invalid_request('leg is bleg, bleg_url has to be specified')
          end
          params[:bleg_url] = options[:bleg_url]
        end

        if options[:legs] == 'both'
          unless options.key?(:aleg_url) && options.key?(:bleg_url)
            raise_invalid_request('leg is both, aleg_url & bleg_url have to be specified')
          end
          params[:aleg_url] = options[:aleg_url]
          params[:bleg_url] = options[:bleg_url]
        end

        %i[aleg_method bleg_method].each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true, %w[GET POST])
            params[param] = options[param]
          end
        end

        perform_update(params)
      end

      def delete
        perform_delete
      end

      def record(options = nil)
        return perform_action('Record', 'POST', nil, true) if options.nil?
        valid_param?(:options, options, Hash, true)

        params = {}
        %i[transcription_url callback_url].each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end

        %i[transcription_method callback_method].each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true, %w[GET POST])
            params[param] = options[param]
          end
        end

        if options.key?(:time_limit) &&
           valid_param?(:time_limit, options[:time_limit], Integer, true)
          params[:time_limit] = options[:time_limit]
        end

        if options.key?(:file_format) &&
           valid_param?(:file_format, options[:file_format],
                        [String, Symbol], true, %w[wav mp3])
          params[:file_format] = options[:file_format]
        end

        if options.key?(:transcription_type) &&
           valid_param?(:transcription_type, options[:transcription_type],
                        [String, Symbol], true, %w[auto hybrid])
          params[:transcription_type] = options[:transcription_type]
        end

        perform_action('Record', 'POST', params, true)
      end

      def stop_record(url = nil)
        if !url.nil? &&
           valid_param?(:URL, url, [String, Symbol], true)
          return perform_action('Record', 'DELETE', { URL: url }, false)
        end
        perform_action('Record', 'DELETE')
      end

      def play(urls, options = nil)
        valid_param?(:urls, urls, Array, true)
        if options.nil?
          return perform_action('Play', 'POST', { urls: urls.join(',') }, true)
        end
        valid_param?(:options, options, Hash, true)

        params = { urls: urls.join(',') }

        if options.key?(:length) &&
           valid_param?(:length, options[:length], Integer, true)
          params[:length] = options[:length]
        end

        if options.key?(:legs) &&
           valid_param?(:legs, options[:legs],
                        [String, Symbol], true, %w[aleg bleg both])
          params[:legs] = options[:legs]
        end

        %i[loop mix].each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [TrueClass, FalseClass], true)
            params[param] = options[param]
          end
        end

        perform_action('Play', 'POST', params, true)
      end

      def stop_play
        perform_action('Play', 'DELETE', nil, false)
      end

      def speak(text, options = nil)
        valid_param?(:text, text, String, true)
        if options.nil?
          return perform_action('Speak', 'POST', { text: text }, true)
        end
        valid_param?(:options, options, Hash, true)

        params = { text: text }

        if options.key?(:language) &&
           valid_param?(:language, options[:language], String, true)
          params[:language] = options[:language]
        end

        if options.key?(:voice) &&
           valid_param?(:voice, options[:voice],
                        [String, Symbol], true, %w[MAN WOMAN])
          params[:voice] = options[:voice]
        end

        if options.key?(:legs) &&
           valid_param?(:legs, options[:legs],
                        [String, Symbol], true, %w[aleg bleg both])
          params[:legs] = options[:legs]
        end

        %i[loop mix].each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [TrueClass, FalseClass], true)
            params[param] = options[param]
          end
        end

        perform_action('Speak', 'POST', params, true)
      end

      def stop_speak
        perform_action('Speak', 'DELETE', nil, false)
      end

      def send_digits(digits, leg = nil)
        valid_param?(:digits, digits, String, true)

        params = { digits: digits }

        if !leg.nil? &&
           valid_param?(:leg, leg,
                        [String, Symbol], true, %w[aleg bleg both])
          params[:leg] = leg
        end

        perform_action('DTMF', 'POST', params, true)
      end

      def cancel_request
        resource_path = @_resource_uri.sub('Call', 'Request')
        @_client.send_request(resource_path, 'DELETE', nil, nil, false , is_voice_request: @_is_voice_request)
      end

      def start_stream(service_url, options = nil)
        valid_param?(:service_url, service_url, [String, Symbol], true)
        if options.nil?
          return perform_action('Stream', 'POST', { service_url: service_url }, true)
        end

        valid_param?(:options, options, Hash, true)

        params = { service_url: service_url }

        if options.key?(:bidirectional) &&
          valid_param?(:bidirectional, options[:bidirectional], [TrueClass, FalseClass], false )
          params[:bidirectional] = options[:bidirectional]
        end

        if options.key?(:audio_track) &&
          valid_param?(:audio_track, options[:audio_track],
                       [String, Symbol], false, %w[inbound outbound both])
          params[:audio_track] = options[:audio_track]
        end

        if options.key?(:stream_timeout) &&
          valid_param?(:stream_timeout, options[:stream_timeout], Integer, false)
          params[:stream_timeout] = options[:stream_timeout]
        end

        if options.key?(:status_callback_url) &&
          valid_param?(:status_callback_url, options[:status_callback_url], [String, Symbol], false)
          params[:status_callback_url] = options[:status_callback_url]
        end

        if options.key?(:status_callback_method) &&
          valid_param?(:status_callback_method, options[:status_callback_method],
                       [String, Symbol], false, %w[GET POST get post])
          params[:status_callback_method] = options[:status_callback_method]
        end

        if options.key?(:content_type) &&
          valid_param?(:content_type, options[:content_type], [String, Symbol, Integer], false)
          params[:content_type] = options[:content_type]
        end

        if options.key?(:extra_headers) &&
          valid_param?(:extra_headers, options[:extra_headers], [String], false)
          params[:extra_headers] = options[:extra_headers]
        end
        perform_action('Stream', 'POST', params, true)
      end

      def stop_all_streams
        perform_action('Stream', 'DELETE', nil, false)
      end

      def stop_stream(stream_id)
        valid_param?(:stream_id, stream_id, [String, Symbol, Integer], true)
        perform_action('Stream/' + stream_id, 'DELETE', nil, false)
      end

      def get_all_streams
        perform_action('Stream', 'GET', nil, true )
      end

      def get_stream(stream_id)
        valid_param?(:stream_id, stream_id, [String, Symbol, Integer], true)
        perform_action('Stream/' + stream_id, 'GET', nil, true)
      end

      def to_s
        call_details = {
          answer_time: @answer_time,
          api_id: @api_id,
          bill_duration: @bill_duration,
          billed_duration: @billed_duration,
          call_direction: @call_direction,
          call_duration: @call_duration,
          call_status: @call_status,
          call_state: @call_state,
          call_uuid: @call_uuid,
          conference_uuid: @conference_uuid,
          end_time: @end_time,
          from_number: @from_number,
          initiation_time: @initiation_time,
          parent_call_uuid: @parent_call_uuid,
          hangup_cause_code: @hangup_cause_code,
          hangup_cause_name: @hangup_cause_name,
          hangup_source: @hangup_source,
          resource_uri: @resource_uri,
          to_number: @to_number,
          total_amount: @total_amount,
          total_rate: @total_rate,
          to: @to,
          from: @from,
          request_uuid: @request_uuid,
          direction: @direction,
          caller_name: @caller_name,
          stir_verification: @stir_verification,
          stir_attestation: @stir_attestation,
          source_ip: @source_ip,
          cnam_lookup: @cnam_lookup
        }
        call_details = call_details.select {|k, v| !v.nil? }
        call_details.to_s
      end
    end

    class CallInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Call'
        @_resource_type = Call
        @_identifier_string = 'call_uuid'
        super
        @_is_voice_request = true
      end

      ##
      # Makes an outbound call
      #
      # @param [String] from
      # @param [Array] to
      # @param [String] answer_url
      # @param [Hash] options
      # @option options [String] :answer_method - The method used to call the answer_url. Defaults to POST.
      # @option options [String] :ring_url - The URL that is notified by Plivo when the call is ringing. Defaults not set.
      # @option options [String] :ring_method - The method used to call the ring_url. Defaults to POST.
      # @option options [String] :hangup_url - The URL that will be notified by Plivo when the call hangs up. Defaults to answer_url.
      # @option options [String] :hangup_method - The method used to call the hangup_url. Defaults to POST.
      # @option options [String] :fallback_url - Invoked by Plivo only if answer_url is unavailable or the XML response is invalid. Should contain a XML response.
      # @option options [String] :fallback_method - The method used to call the fallback_answer_url. Defaults to POST.
      # @option options [String] :caller_name - Caller name to use with the call.
      # @option options [String] :send_digits - Plivo plays DTMF tones when the call is answered. This is useful when dialing a phone number and an extension. Plivo will dial the number, and when the automated system picks up, sends the DTMF tones to connect to the extension. E.g. If you want to dial the 2410 extension after the call is connected, and you want to wait for a few seconds before sending the extension, add a few leading 'w' characters. Each 'w' character waits 0.5 second before sending a digit. Each 'W' character waits 1 second before sending a digit. You can also add the tone duration in ms by appending @duration after the string (default duration is 2000 ms). For example, 1w2w3@1000 See the DTMF API for additional information.
      # @option options [Boolean] :send_on_preanswer - If set to true and send_digits is also set, digits are sent when the call is in preanswer state. Defaults to false.
      # @option options [Int] :time_limit - Schedules the call for hangup at a specified time after the call is answered. Value should be an integer > 0(in seconds).
      # @option options [Int] :hangup_on_ring - Schedules the call for hangup at a specified time after the call starts ringing. Value should be an integer >= 0 (in seconds).
      # @option options [String] :machine_detection - Used to detect if the call has been answered by a machine. The valid values are true and hangup. Default time to analyze is 5000 milliseconds (or 5 seconds). You can change it with the machine_detection_time parameter. Note that no XML is processed during the analysis phase. If a machine is detected during the call and machine_detection is set to true, the Machine parameter will be set to true and will be sent to the answer_url, hangup_url, or any other URL that is invoked by the call. If a machine is detected during the call and machine_detection is set to hangup, the call hangs up immediately and a request is made to the hangup_url with the Machine parameter set to true
      # @option options [Int] :machine_detection_time - Time allotted to analyze if the call has been answered by a machine. It should be an integer >= 2000 and <= 10000 and the unit is ms. The default value is 5000 ms.
      # @option options [String] :machine_detection_url - A URL where machine detection parameters will be sent by Plivo. This parameter should be used to make machine detection asynchronous
      # @option options [String] :machine_detection_method - The HTTP method which will be used by Plivo to request the machine_detection_url. Defaults to POST.
      # @option options [String] :sip_headers- List of SIP headers in the form of 'key=value' pairs, separated by commas. E.g. head1=val1,head2=val2,head3=val3,...,headN=valN. The SIP headers are always prefixed with X-PH-. The SIP headers are present for every HTTP request made by the outbound call. Only [A-Z], [a-z] and [0-9] characters are allowed for the SIP headers key and value. Additionally, the '%' character is also allowed for the SIP headers value so that you can encode this value in the URL.
      # @option options [Int] :ring_timeout - Determines the time in seconds the call should ring. If the call is not answered within the ring_timeout value or the default value of 120s, it is canceled.
      # @option options [String] :parent_call_uuid - The call_uuid of the first leg in an ongoing conference call. It is recommended to use this parameter in scenarios where a member who is already present in the conference intends to add new members by initiating outbound API calls. This minimizes the delay in adding a new memeber to the conference.
      # @option options [Boolean] :error_parent_not_found - if set to true and the parent_call_uuid cannot be found, the API request would return an error. If set to false, the outbound call API request will be executed even if the parent_call_uuid is not found. Defaults to false.
      # @return [Call] Call
      def create(from, to, answer_url, options = nil)
        valid_param?(:from, from, [String, Symbol, Integer], true)
        valid_param?(:to, to, Array, true)
        to.each do |to_num|
          valid_param?(:to_num, to_num, [Integer, String, Symbol], true)
        end
        valid_param?(:answer_url, answer_url, [String, Symbol], true)


        params = {
          from: from,
          to: to.join('<'),
          answer_url: answer_url,
        }

        return perform_create(params, false) if options.nil?

        perform_create(params.merge(options), false)
      end

      ##
      # Get details of a call
      # @param [String] call_uuid
      def get(call_uuid)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true)
        perform_get(call_uuid)
      end

      # @param [String] call_uuid
      def get_live(call_uuid)
        perform_get(call_uuid, status: 'live')
      end

      # @param [String] call_uuid
      def get_queued(call_uuid)
        perform_get(call_uuid, status: 'queued')
      end

      # @param [Hash] options
      # @option options [String] :subaccount - The id of the subaccount, if call details of the subaccount are needed.
      # @option options [String] :call_direction - Filter the results by call direction. The valid inputs are inbound and outbound.
      # @option options [String] :from_number - Filter the results by the number from where the call originated. For example:
      #                                       - To filter out those numbers that contain a particular number sequence, use from_number={ sequence}
      #                                       - To filter out a number that matches an exact number, use from_number={ exact_number}
      # @option options [String] :to_number - Filter the results by the number to which the call was made. Tips to use this filter are:
      #                                     - To filter out those numbers that contain a particular number sequence, use to_number={ sequence}
      #                                     - To filter out a number that matches an exact number, use to_number={ exact_number}
      # @option options [String] :bill_duration - Filter the results according to billed duration. The value of billed duration is in seconds. The filter can be used in one of the following five forms:
      #                                         - bill_duration: Input the exact value. E.g., to filter out calls that were exactly three minutes long, use bill_duration=180
      #                                         - bill_duration\__gt: gt stands for greater than. E.g., to filter out calls that were more than two hours in duration bill_duration\__gt=7200
      #                                         - bill_duration\__gte: gte stands for greater than or equal to. E.g., to filter out calls that were two hours or more in duration bill_duration\__gte=7200
      #                                         - bill_duration\__lt: lt stands for lesser than. E.g., to filter out calls that were less than seven minutes in duration bill_duration\__lt=420
      #                                         - bill_duration\__lte: lte stands for lesser than or equal to. E.g., to filter out calls that were two hours or less in duration bill_duration\__lte=7200
      # @option options [String] :end_time - Filter out calls according to the time of completion. The filter can be used in the following five forms:
      #                                    - end_time: The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. E.g., To get all calls that ended at 2012-03-21 11:47[:30], use end_time=2012-03-21 11:47[:30]
      #                                    - end_time\__gt: gt stands for greater than. The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. E.g., To get all calls that ended after 2012-03-21 11:47, use end_time\__gt=2012-03-21 11:47
      #                                    - end_time\__gte: gte stands for greater than or equal. The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. E.g., To get all calls that ended after or exactly at 2012-03-21 11:47[:30], use end_time\__gte=2012-03-21 11:47[:30]
      #                                    - end_time\__lt: lt stands for lesser than. The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. E.g., To get all calls that ended before 2012-03-21 11:47, use end_time\__lt=2012-03-21 11:47
      #                                    - end_time\__lte: lte stands for lesser than or equal. The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. E.g., To get all calls that ended before or exactly at 2012-03-21 11:47[:30], use end_time\__lte=2012-03-21 11:47[:30]
      #                                    - Note: The above filters can be combined to get calls that ended in a particular time range. The timestamps need to be UTC timestamps.
      # @option options [String] :parent_call_uuid - Filter the results by parent call uuid.
      # @option options [String] :hangup_source - Filter the results by hangup source
      # @option options [String] :hangup_cause_code - Filter the results by hangup cause code
      # @option options [Int] :limit - Used to display the number of results per page. The maximum number of results that can be fetched is 20.
      # @option options [Int] :offset - Denotes the number of value items by which the results should be offset. E.g., If the result contains a 1000 values and limit is set to 10 and offset is set to 705, then values 706 through 715 are displayed in the results. This parameter is also used for pagination of the results.

      def list(options = nil)
        return perform_list if options.nil?
        valid_param?(:options, options, Hash, true)

        raise_invalid_request("Offset can't be negative") if options.key?(:offset) && options[:offset] < 0

        if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
          raise_invalid_request('The maximum number of results that can be '\
          "fetched is 20. limit can't be more than 20 or less than 1")
        end

        # initial list of possible params
        params = %i[
          bill_duration
          bill_duration__gt
          bill_duration__gte
          bill_duration__lt
          bill_duration__lte
          call_direction
          end_time
          end_time__gt
          end_time__gte
          end_time__lt
          end_time__lte
          from_number
          hangup_cause_code
          hangup_source
          limit
          offset
          parent_call_uuid
          subaccount
          to_number
          stir_verification
        ].reduce({}) do |result_hash, param|
          if options.key?(param)
            if param == :call_direction
              if valid_param?(:call_direction, options[:call_direction],
                  [String, Symbol], true, %w[inbound outbound])
                result_hash[:call_direction] = options[:call_direction]
              end
            elsif %i[offset limit hangup_cause_code].include?(param)
              if valid_param?(param, options[param], [Integer, Integer], true)
                result_hash[param] = options[param]
              end
            elsif valid_param?(param, options[param], [String, Symbol], true)
              result_hash[param] = options[param]
            end
          end

          result_hash
        end

        perform_list(params)
      end

      def each
        offset = 0
        loop do
          call_list = list(offset: offset)
          call_list[:objects].each { |call| yield call }
          offset += 20
          return unless call_list.length == 20
        end
      end

      # @param [Hash] options
      # @option options [String] :call_direction - Filter the results by call direction. The valid inputs are inbound and outbound.
      # @option options [String] :from_number - Filter the results by the number from where the call originated. For example:
      #                                       - To filter out those numbers that contain a particular number sequence, use from_number={ sequence}
      #                                       - To filter out a number that matches an exact number, use from_number={ exact_number}
      # @option options [String] :to_number - Filter the results by the number to which the call was made. Tips to use this filter are:
      #                                     - To filter out those numbers that contain a particular number sequence, use to_number={ sequence}
      #                                     - To filter out a number that matches an exact number, use to_number={ exact_number}
      def list_live(options = nil)

        if options.nil?
          options = {}
        else
          valid_param?(:options, options, Hash, true)
        end

        params = {}
        params[:status] = 'live'
        params_expected = %i[
          from_number to_number
        ]
        params_expected.each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end

        if options.key?(:call_direction) &&
          valid_param?(:call_direction, options[:call_direction],
                       [String, Symbol], true, %w[inbound outbound])
         params[:call_direction] = options[:call_direction]
        end

        perform_list_without_object(params)
        {
          api_id: @api_id,
          calls: @calls
        }
      end

      def list_queued
        perform_list_without_object(status: 'queued')
        {
            api_id: @api_id,
            calls: @calls
        }
       end

      def each_live
        call_list = list_live
        call_list[:calls].each { |call| yield call }
      end

      def each_queued
        call_queued = list_queued
        call_queued[:calls].each { |call| yield call}
      end

      ##
      # Transfer a call
      # @param [String] call_uuid
      # @param [Hash] details
      # @option details [String] :legs - aleg, bleg or both Defaults to aleg. aleg will transfer call_uuid ; bleg will transfer the bridged leg (if found) of call_uuid ; both will transfer call_uuid and bridged leg of call_uuid
      # @option details [String] :aleg_url - URL to transfer for aleg, if legs is aleg or both, then aleg_url has to be specified.
      # @option details [String] :aleg_method - HTTP method to invoke aleg_url. Defaults to POST.
      # @option details [String] :bleg_url - URL to transfer for bridged leg, if legs is bleg or both, then bleg_url has to be specified.
      # @option details [String] :bleg_method - HTTP method to invoke bleg_url. Defaults to POST.
      # @return [Call] Call
      def update(call_uuid, details)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true)
        Call.new(@_client, resource_id: call_uuid).update(details)
      end

      # @param [String] call_uuid
      def delete(call_uuid)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true)
        Call.new(@_client, resource_id: call_uuid).delete
      end

      # @param [String] call_uuid
      # @param [Hash] options
      # @option options [Int] :time_limit - Max recording duration in seconds. Defaults to 60.
      # @option options [String] :file_format - The format of the recording. The valid formats are mp3 and wav formats. Defaults to mp3.
      # @option options [String] :transcription_type - The type of transcription required. The following values are allowed:
      #                                              - auto - This is the default value. Transcription is completely automated; turnaround time is about 5 minutes.
      #                                              - hybrid - Transcription is a combination of automated and human verification processes; turnaround time is about 10-15 minutes.
      #                                              - *Our transcription service is primarily for the voicemail use case (limited to recorded files lasting for up to 2 minutes). Currently the service is available only in English and you will be charged for the usage. Please check out the price details.
      # @option options [String] :transcription_url - The URL where the transcription is available.
      # @option options [String] :transcription_method - The method used to invoke the transcription_url. Defaults to POST.
      # @option options [String] :callback_url - The URL invoked by the API when the recording ends. The following parameters are sent to the callback_url:
      #                                        - api_id - the same API ID returned by the call record API.
      #                                        - record_url - the URL to access the recorded file.
      #                                        - call_uuid - the call uuid of the recorded call.
      #                                        - recording_id - the recording ID of the recorded call.
      #                                        - recording_duration - duration in seconds of the recording.
      #                                        - recording_duration_ms - duration in milliseconds of the recording.
      #                                        - recording_start_ms - when the recording started (epoch time UTC) in milliseconds.
      #                                        - recording_end_ms - when the recording ended (epoch time UTC) in milliseconds.
      # @option options [String] :callback_method - The method which is used to invoke the callback_url URL. Defaults to POST.
      def record(call_uuid, options = nil)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true)
        response = Call.new(@_client, resource_id: call_uuid).record(options)
        return Base::Response.new(Hash["api_id" => response.api_id,
                                       "recording_id" => response.recording_id,
                                       "message" => response.message,
                                       "url" => response.url])
      end

      # @param [String] call_uuid
      # @param [String] url - You can specify a record URL to stop only one record. By default all recordings are stopped.
      def stop_record(call_uuid, url = nil)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true)
        Call.new(@_client, resource_id: call_uuid).stop_record(url)
      end

      # @param [String] call_uuid
      # @param [Array] urls
      # @param [Hash] options
      # @option options [Array of strings] :urls - A single URL or a list of comma separated URLs linking to an mp3 or wav file.
      # @option options [Int] :length - Maximum length in seconds that the audio should be played.
      # @option options [String] :legs - The leg on which the music will be played, can be aleg (i.e., A-leg is the first leg of the call or current call), bleg (i.e., B-leg is the second leg of the call),or both (i.e., both legs of the call).
      # @option options [Boolean] :loop - If set to true, the audio file will play indefinitely.
      # @option options [Boolean] :mix - If set to true, sounds are mixed with current audio flow.
      def play(call_uuid, urls, options = nil)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true)
        valid_param?(:urls, urls, Array, true)
        Call.new(@_client, resource_id: call_uuid).play(urls, options)
      end

      # @param [String] call_uuid
      def stop_play(call_uuid)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true)
        Call.new(@_client, resource_id: call_uuid).stop_play
      end

      # @param [String] call_uuid
      # @param [String] text
      # @param [Hash] options
      # @option options [String] :voice - The voice to be used, can be MAN, WOMAN.
      # @option options [Int] :language - The language to be used, see Supported voices and languages {https://www.plivo.com/docs/api/call/speak/#supported-voices-and-languages}
      # @option options [String] :legs - The leg on which the music will be played, can be aleg (i.e., A-leg is the first leg of the call or current call), bleg (i.e., B-leg is the second leg of the call),or both (i.e., both legs of the call).
      # @option options [Boolean] :loop - If set to true, the audio file will play indefinitely.
      # @option options [Boolean] :mix - If set to true, sounds are mixed with current audio flow.
      def speak(call_uuid, text, options = nil)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true)
        Call.new(@_client, resource_id: call_uuid).speak(text, options)
      end

      # @param [String] call_uuid
      def stop_speak(call_uuid)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true)
        Call.new(@_client, resource_id: call_uuid).stop_speak
      end

      # @param [String] call_uuid
      # @param [String] digits - Digits to be sent.
      # @param [String] leg - The leg to be used, can be aleg (the current call) or bleg (the other party in a Dial). Defaults to aleg.
      def send_digits(call_uuid, digits, leg = nil)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true)
        Call.new(@_client, resource_id: call_uuid).send_digits(digits, leg)
      end

      # @param [String] call_uuid
      def cancel_request(call_uuid)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true)
        Call.new(@_client, resource_id: call_uuid).cancel_request
      end

      # @param [String] service_url
      # @param [Hash] options
      # @option options [Boolean] :bidirectional
      # @option options [String] :audio_track
      # @option options [Int] :stream_timeout
      # @option options [String] :status_callback_url
      # @option options [String] :status_callback_method
      # @option options [String] :content_type
      # @option options [String] :extra_headers
      def start_stream(call_uuid, service_url, options = {})
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true)
        response = Call.new(@_client, resource_id: call_uuid).start_stream(service_url, options)
        return Base::Response.new(Hash["api_id" => response.api_id,
                                       "stream_id" => response.stream_id,
                                       "message" => response.message])
      end

      def stop_all_streams(call_uuid)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true )
        Call.new(@_client, resource_id: call_uuid).stop_all_streams
      end

      def stop_stream(call_uuid, stream_id)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true )
        Call.new(@_client, resource_id: call_uuid).stop_stream(stream_id)
      end

      def get_all_streams(call_uuid)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true )
        response = Call.new(@_client, resource_id: call_uuid).get_all_streams
        return Base::Response.new(Hash["api_id" => response.api_id,
                                       "meta" => response.meta,
                                       "objects" => response.objects])
      end

      def get_stream(call_uuid, stream_id)
        valid_param?(:call_uuid, call_uuid, [String, Symbol], true )
        response = Call.new(@_client, resource_id: call_uuid).get_stream(stream_id)
        return Base::Response.new(Hash["api_id" => response.instance_variable_get(:@api_id),
                                       "audio_track" => response.instance_variable_get(:@audio_track),
                                       "bidirectional" => response.instance_variable_get(:@bidirectional),
                                       "bill_duration" => response.instance_variable_get(:@bill_duration),
                                       "billed_amount" => response.instance_variable_get(:@billed_amount),
                                       "call_uuid" => response.instance_variable_get(:@call_uuid),
                                       "created_at" => response.instance_variable_get(:@created_at),
                                       "end_time" => response.instance_variable_get(:@end_time),
                                       "plivo_auth_id" => response.instance_variable_get(:@plivo_auth_id),
                                       "resource_uri" => response.instance_variable_get(:@resource_uri),
                                       "rounded_bill_duration" => response.instance_variable_get(:@rounded_bill_duration),
                                       "service_url" => response.instance_variable_get(:@service_url),
                                       "start_time" => response.instance_variable_get(:@start_time),
                                       "status" => response.instance_variable_get(:@status),
                                       "status_callback_url" => response.instance_variable_get(:@status_callback_url),
                                       "stream_id" => response.instance_variable_get(:@stream_id)])
      end
    end
  end
end
