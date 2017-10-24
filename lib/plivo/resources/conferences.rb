module Plivo
  module Resources
    include Plivo::Utils
    class Conference < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Conference'
        @_identifier_string = 'conference_name'
        super
      end

      def delete
        perform_delete
      end

      # @param [String] member_id
      def delete_member(member_id)
        valid_param?(:member_id, member_id, [String, Symbol, Integer, Integer], true)
        perform_action('Member/' + member_id.to_s, 'DELETE', nil, true)
      end

      # @param [String] member_id
      def kick_member(member_id)
        valid_param?(:member_id, member_id, [String, Symbol, Integer, Integer], true)
        perform_action('Member/' + member_id.to_s + '/Kick', 'POST', nil, true)
      end

      # @param [Array] member_id
      def mute_member(member_id)
        valid_param?(:member_id, member_id, Array, true)
        member_id.each do |member|
          valid_param?(:member, member, [String, Symbol, Integer, Integer], true)
        end
        perform_action('Member/' + member_id.join(',') + '/Mute',
                       'POST', nil, true)
      end

      # @param [Array] member_id
      def unmute_member(member_id)
        valid_param?(:member_id, member_id, Array, true)
        member_id.each do |member|
          valid_param?(:member, member, [String, Symbol, Integer, Integer], true)
        end
        perform_action('Member/' + member_id.join(',') + '/Mute', 'DELETE')
      end

      # @param [Array] member_id
      # @param [String] url
      def play_member(member_id, url)
        valid_param?(:member_id, member_id, Array, true)
        valid_param?(:url, url, String, true)
        member_id.each do |member|
          valid_param?(:member, member, [String, Symbol, Integer, Integer], true)
        end
        perform_action('Member/' + member_id.join(',') + '/Play',
                       'POST', { url: url }, true)
      end

      # @param [Array] member_id
      def stop_play_member(member_id)
        valid_param?(:member_id, member_id, Array, true)
        member_id.each do |member|
          valid_param?(:member, member, [String, Symbol, Integer, Integer], true)
        end
        perform_action('Member/' + member_id.join(',') + '/Play',
                       'DELETE', nil, true)
      end

      # @param [Array] member_id
      # @param [String] text - The text that the member must hear.
      # @param [Hash] options
      # @option options [String] :voice - The voice to be used. Can be MAN or WOMAN. Defaults to WOMAN.
      # @option options [String] :language - The language to be used, see Supported voices and languages {https://www.plivo.com/docs/api/conference/member/#supported-voice-and-languages}. Defaults to en-US .
      def speak_member(member_id, text, options = nil)
        valid_param?(:member_id, member_id, Array, true)
        valid_param?(:text, text, String, true)
        member_id.each do |member|
          valid_param?(:member, member, [String, Symbol, Integer, Integer], true)
        end

        params = { text: text }

        if options.nil?
          return perform_action('Member/' + member_id.join(',') + '/Speak',
                                'POST', params, true)
        end

        if options.key?(:voice) &&
           valid_param?(:voice, options[:voice],
                        [String, Symbol], true, %w[MAN WOMAN])
          params[:voice] = options[:voice]
        end

        if options.key?(:language) &&
           valid_param?(:language, options[:language],
                        String, true)
          params[:language] = options[:language]
        end

        perform_action('Member/' + member_id.join(',') + '/Speak',
                       'POST', params, true)
      end

      # @param [Array] member_id
      def stop_speak_member(member_id)
        valid_param?(:member_id, member_id, Array, true)
        member_id.each do |member|
          valid_param?(:member, member, [String, Symbol, Integer, Integer], true)
        end
        perform_action('Member/' + member_id.join(',') + '/Speak',
                       'DELETE', nil, true)
      end

      # @param [Array] member_id
      def deaf_member(member_id)
        valid_param?(:member_id, member_id, Array, true)
        member_id.each do |member|
          valid_param?(:member, member, [String, Symbol, Integer, Integer], true)
        end
        perform_action('Member/' + member_id.join(',') + '/Deaf',
                       'POST', nil, true)
      end

      # @param [Array] member_id
      def undeaf_member(member_id)
        valid_param?(:member_id, member_id, Array, true)
        member_id.each do |member|
          valid_param?(:member, member, [String, Symbol, Integer, Integer], true)
        end
        perform_action('Member/' + member_id.join(',') + '/Deaf',
                       'DELETE', nil, true)
      end

      # @param [Hash] options
      # @option options [String] :file_format The file format of the record can be of mp3 or wav format. Defaults to mp3 format.
      # @option options [String] :transcription_type The type of transcription required. The following values are allowed:
      #                                              - auto - This is the default value. Transcription is completely automated; turnaround time is about 5 minutes.
      #                                              - hybrid - Transcription is a combination of automated and human verification processes; turnaround time is about 10-15 minutes.
      # @option options [String] :transcription_url The URL where the transcription is available.
      # @option options [String] :transcription_method The method used to invoke the transcription_url. Defaults to POST.
      # @option options [String] :callback_url The URL invoked by the API when the recording ends. The following parameters are sent to the callback_url:
      #                                        - api_id - the same API ID returned by the conference record API.
      #                                        - record_url - the URL to access the recorded file.
      #                                        - recording_id - recording ID of the recorded file.
      #                                        - conference_name - the conference name recorded.
      #                                        - recording_duration - duration in seconds of the recording.
      #                                        - recording_duration_ms - duration in milliseconds of the recording.
      #                                        - recording_start_ms - when the recording started (epoch time UTC) in milliseconds.
      #                                        - recording_end_ms - when the recording ended (epoch time UTC) in milliseconds.
      # @option options [String] :callback_method The method which is used to invoke the callback_url URL. Defaults to POST.
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

      def stop_record
        perform_action('Record', 'DELETE')
      end

      def to_s
        unless @members.nil?
          members_json = @members.map do |member|
            JSON.parse(to_json_member(member))
          end
        end
        {
          conference_name: @conference_name,
          conference_run_time: @conference_run_time,
          conference_member_count: @conference_member_count,
          members: members_json,
          api_id: @api_id
        }.to_s
      end

      def to_json_member(member)
        {
          muted: member['muted'],
          member_id: member['member_id'],
          deaf: member['deaf'],
          from: member['from'],
          to: member['to'],
          caller_name: member['caller_name'],
          direction: member['direction'],
          call_uuid: member['call_uuid'],
          join_time: member['join_time']
        }.to_json
      end
    end

    class ConferenceInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Conference'
        @_resource_type = Conference
        @_identifier_string = 'conference_name'
        super
      end

      def get(conference_name)
        perform_get(conference_name)
      end

      def list
        perform_list_without_object
        {
          api_id: @api_id,
          conferences: @conferences
        }
      end

      def each
        conference_list = list
        conference_list[:conferences].each { |conference| yield conference }
      end

      def delete_all
        Conference.new(@_client, resource_id: '').delete
      end

      def delete(conference_name)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        if conference_name.empty?
          raise_invalid_request('Invalid conference_name passed')
        end
        Conference.new(@_client, resource_id: conference_name).delete
      end

      # @param [String] conference_name
      # @param [String] member_id
      def delete_member(conference_name, member_id)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        Conference.new(@_client, resource_id: conference_name)
                  .delete_member(member_id)
      end

      # @param [String] conference_name
      # @param [String] member_id
      def kick_member(conference_name, member_id)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        Conference.new(@_client, resource_id: conference_name)
                  .kick_member(member_id)
      end

      # @param [String] conference_name
      # @param [Array] member_id
      def mute_member(conference_name, member_id)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        Conference.new(@_client, resource_id: conference_name)
                  .mute_member(member_id)
      end

      # @param [String] conference_name
      # @param [Array] member_id
      def unmute_member(conference_name, member_id)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        Conference.new(@_client, resource_id: conference_name)
                  .unmute_member(member_id)
      end

      # @param [String] conference_name
      # @param [Array] member_id
      def play_member(conference_name, member_id, url)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        Conference.new(@_client, resource_id: conference_name)
                  .play_member(member_id, url)
      end

      # @param [String] conference_name
      # @param [Array] member_id
      def stop_play_member(conference_name, member_id)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        Conference.new(@_client, resource_id: conference_name)
                  .stop_play_member(member_id)
      end

      # @param [String] conference_name
      # @param [Array] member_id
      # @param [String] text - The text that the member must hear.
      # @param [Hash] options
      # @option options [String] :voice - The voice to be used. Can be MAN or WOMAN. Defaults to WOMAN.
      # @option options [String] :language - The language to be used, see Supported voices and languages {https://www.plivo.com/docs/api/conference/member/#supported-voice-and-languages}. Defaults to en-US .
      def speak_member(conference_name, member_id, text, options = nil)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        Conference.new(@_client, resource_id: conference_name)
                  .speak_member(member_id, text, options)
      end

      # @param [String] conference_name
      # @param [Array] member_id
      def stop_speak_member(conference_name, member_id)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        Conference.new(@_client, resource_id: conference_name)
                  .stop_speak_member(member_id)
      end

      # @param [String] conference_name
      # @param [Array] member_id
      def deaf_member(conference_name, member_id)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        Conference.new(@_client, resource_id: conference_name)
                  .deaf_member(member_id)
      end

      # @param [String] conference_name
      # @param [Array] member_id
      def undeaf_member(conference_name, member_id)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        Conference.new(@_client, resource_id: conference_name)
                  .undeaf_member(member_id)
      end

      # @param [String] conference_name
      # @param [Hash] options
      # @option options [String] :file_format The file format of the record can be of mp3 or wav format. Defaults to mp3 format.
      # @option options [String] :transcription_type The type of transcription required. The following values are allowed:
      #                                              - auto - This is the default value. Transcription is completely automated; turnaround time is about 5 minutes.
      #                                              - hybrid - Transcription is a combination of automated and human verification processes; turnaround time is about 10-15 minutes.
      # @option options [String] :transcription_url The URL where the transcription is available.
      # @option options [String] :transcription_method The method used to invoke the transcription_url. Defaults to POST.
      # @option options [String] :callback_url The URL invoked by the API when the recording ends. The following parameters are sent to the callback_url:
      #                                        - api_id - the same API ID returned by the conference record API.
      #                                        - record_url - the URL to access the recorded file.
      #                                        - recording_id - recording ID of the recorded file.
      #                                        - conference_name - the conference name recorded.
      #                                        - recording_duration - duration in seconds of the recording.
      #                                        - recording_duration_ms - duration in milliseconds of the recording.
      #                                        - recording_start_ms - when the recording started (epoch time UTC) in milliseconds.
      #                                        - recording_end_ms - when the recording ended (epoch time UTC) in milliseconds.
      # @option options [String] :callback_method The method which is used to invoke the callback_url URL. Defaults to POST.
      def record(conference_name, options = nil)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        Conference.new(@_client, resource_id: conference_name)
                  .record(options)
      end

      # @param [String] conference_name
      def stop_record(conference_name)
        valid_param?(:conference_name, conference_name, [String, Symbol], true)
        Conference.new(@_client, resource_id: conference_name)
                  .stop_record
      end
    end
  end
end
