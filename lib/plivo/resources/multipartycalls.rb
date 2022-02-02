module Plivo
  module Resources
    include Plivo::Utils
    class MultiPartyCall < Base::Resource
      def initialize(client, options = nil)
        @_name = 'MultiPartyCall'
        @_identifier_string = 'mpc_uuid'
        super
        @_is_voice_request = true
        if options.key? :multi_party_prefix
          @id = options[:multi_party_prefix] + '_' + @id
        else
          @id = 'uuid_' + @id
        end
        configure_resource_uri
      end

      def get
        perform_action(nil,'GET',nil,true)
      end

      def add_participant(role,
                          from=nil,
                          to=nil,
                          call_uuid=nil,
                          caller_name=nil,
                          call_status_callback_url=nil,
                          call_status_callback_method='POST',
                          sip_headers=nil,
                          confirm_key=nil,
                          confirm_key_sound_url=nil,
                          confirm_key_sound_method='GET',
                          dial_music='Real',
                          ring_timeout=45,
                          delay_dial=0,
                          max_duration=14400,
                          max_participants=10,
                          wait_music_url=nil,
                          wait_music_method='GET',
                          agent_hold_music_url=nil,
                          agent_hold_music_method='GET',
                          customer_hold_music_url=nil,
                          customer_hold_music_method='GET',
                          recording_callback_url=nil,
                          recording_callback_method='GET',
                          status_callback_url=nil,
                          status_callback_method='GET',
                          on_exit_action_url=nil,
                          on_exit_action_method='POST',
                          record=false,
                          record_file_format='mp3',
                          status_callback_events='mpc-state-changes,participant-state-changes',
                          stay_alone=false,
                          coach_mode=true,
                          mute=false,
                          hold=false,
                          start_mpc_on_enter=false,
                          end_mpc_on_exit=false,
                          relay_dtmf_inputs=false,
                          enter_sound='beep:1',
                          enter_sound_method='GET',
                          exit_sound='beep:2',
                          exit_sound_method='GET',
                          start_recording_audio=nil,
                          start_recording_audio_method='GET',
                          stop_recording_audio=nil,
                          stop_recording_audio_method='GET')
        if (from and to) and call_uuid
          raise_invalid_request('cannot specify call_uuid when (from, to) is provided')
        end
        if not from and not to and not call_uuid
          raise_invalid_request('specify either call_uuid or (from, to)')
        end
        if call_uuid.nil? and (not from or not to)
          raise_invalid_request('specify (from, to) when not adding an existing call_uuid to multi party participant')
        end

        valid_param?(:role, role.downcase, String, true, %w[agent supervisor customer])
        valid_param?(:from, from, String, false ) unless from.nil?
        valid_param?(:to, to, String, false ) unless to.nil?
        valid_multiple_destination_nos?(:to, to, role: role, delimiter: '<', agent_limit: 20) unless to.nil?
        valid_param?(:call_uuid, call_uuid, String, false ) unless call_uuid.nil?
        valid_param?(:caller_name, caller_name, String, false) unless caller_name.nil?
        valid_range?(:caller_name, caller_name.length, false, 0, 50) unless caller_name.nil?
        valid_url?(:call_status_callback_url, call_status_callback_url, false) unless call_status_callback_url.nil?
        valid_param?(:call_status_callback_method, call_status_callback_method.upcase, String, false, %w[GET POST])
        valid_param?(:sip_headers, sip_headers, String, false) unless sip_headers.nil?
        valid_param?(:confirm_key, confirm_key, String, false , %w[0 1 2 3 4 5 6 7 8 9 # *]) unless confirm_key.nil?
        valid_url?(:confirm_key_sound_url, confirm_key_sound_url, false) unless confirm_key_sound_url.nil?
        valid_param?(:confirm_key_sound_method, confirm_key_sound_method.upcase, String, false, %w[GET POST])
        is_one_among_string_url?(:dial_music, dial_music, false, %w[real none])
        valid_param?(:ring_timeout, ring_timeout, [String,Integer], false)
        valid_multiple_destination_integers?(:ring_timeout, ring_timeout)
        valid_param?(:delay_dial, delay_dial, [String,Integer], false)
        valid_multiple_destination_integers?(:delay_dial, delay_dial)
        valid_range?(:max_duration, max_duration, false, 300, 28800)
        valid_range?(:max_participants, max_participants, false, 2, 10)
        valid_url?(:wait_music_url, wait_music_url, false ) unless wait_music_url.nil?
        valid_param?(:wait_music_method, wait_music_method.upcase, String, false , %w[GET POST])
        valid_url?(:agent_hold_music_url, agent_hold_music_url, false) unless agent_hold_music_url.nil?
        valid_param?(:agent_hold_music_method, agent_hold_music_method.upcase, String, false , %w[GET POST])
        valid_url?(:customer_hold_music_url, customer_hold_music_url, false) unless customer_hold_music_url.nil?
        valid_param?(:customer_hold_music_method, customer_hold_music_method.upcase, String, false, %w[GET POST])
        valid_url?(:recording_callback_url, recording_callback_url, false) unless recording_callback_url.nil?
        valid_param?(:recording_callback_method, recording_callback_method.upcase, String, false, %w[GET POST])
        valid_url?(:status_callback_url, status_callback_url, false) unless status_callback_url.nil?
        valid_param?(:status_callback_method, status_callback_method.upcase, String, false, %w[GET POST])
        valid_url?(:on_exit_action_url, on_exit_action_url, false ) unless on_exit_action_url.nil?
        valid_param?(:on_exit_action_method, on_exit_action_method.upcase, String, false, %w[GET POST])
        valid_param?(:record, record, [TrueClass, FalseClass], false )
        valid_param?(:record_file_format, record_file_format.downcase, String, false, %w[mp3 wav])
        multi_valid_param?(:status_callback_events, status_callback_events.downcase, String, false, %w[mpc-state-changes participant-state-changes participant-speak-events participant-digit-input-events add-participant-api-events], true, ',')
        valid_param?(:stay_alone, stay_alone, [TrueClass, FalseClass], false)
        valid_param?(:coach_mode, coach_mode, [TrueClass, FalseClass], false)
        valid_param?(:mute, mute, [TrueClass, FalseClass],false)
        valid_param?(:hold, hold, [TrueClass, FalseClass], false)
        valid_param?(:start_mpc_on_enter, start_mpc_on_enter, [TrueClass, FalseClass], false)
        valid_param?(:end_mpc_on_exit, end_mpc_on_exit, [TrueClass, FalseClass], false)
        valid_param?(:relay_dtmf_inputs, relay_dtmf_inputs, [TrueClass, FalseClass], false)
        is_one_among_string_url?(:enter_sound, enter_sound, false, %w[beep:1 beep:2 none])
        valid_param?(:enter_sound_method, enter_sound_method.upcase, String, false, %w[GET POST])
        is_one_among_string_url?(:exit_sound, exit_sound, false , %w[beep:1 beep:2 none])
        valid_param?(:exit_sound_method, exit_sound_method.upcase, String, false, %w[GET POST])
        valid_param?(:start_recording_audio_method, start_recording_audio_method.upcase, String, false, %w[GET POST])
        valid_url?(:start_recording_audio, start_recording_audio, false ) unless start_recording_audio.nil?
        valid_param?(:stop_recording_audio_method, stop_recording_audio_method.upcase, String, false, %w[GET POST])
        valid_url?(:stop_recording_audio, stop_recording_audio, false ) unless stop_recording_audio.nil?
        if (to!=nil) && (ring_timeout.is_a?(String)) && (to.split('<').size < ring_timeout.split('<').size)
          raise_invalid_request("RingTimeout:number of ring_timout(s) should be same as number of destination(s)")
        end
          
        if (to!=nil) && (delay_dial.is_a?(String)) && (to.split('<').size < delay_dial.split('<').size)
          raise_invalid_request("Delaydial : number of delay_dial(s) should be same as number of destination(s)")
        end

        params = {}
        params[:role] = role unless role.nil?
        params[:from] = from unless from.nil?
        params[:to] = to unless to.nil?
        params[:call_uuid] = call_uuid unless call_uuid.nil?
        params[:caller_name] = caller_name || from
        params[:call_status_callback_url] = call_status_callback_url unless call_status_callback_url.nil?
        params[:call_status_callback_method] = call_status_callback_method.upcase unless call_status_callback_method.nil?
        params[:sip_headers] = sip_headers unless sip_headers.nil?
        params[:confirm_key] = confirm_key unless confirm_key.nil?
        params[:confirm_key_sound_url] = confirm_key_sound_url unless confirm_key_sound_url.nil?
        params[:confirm_key_sound_method] = confirm_key_sound_method.upcase unless confirm_key_sound_method.nil?
        params[:dial_music] = dial_music unless dial_music.nil?
        params[:ring_timeout] = ring_timeout unless ring_timeout.nil?
        params[:delay_dial] = delay_dial unless delay_dial.nil?
        params[:max_duration] = max_duration unless max_duration.nil?
        params[:max_participants] = max_participants unless max_participants.nil?
        params[:wait_music_url] = wait_music_url unless wait_music_url.nil?
        params[:wait_music_method] = wait_music_method.upcase unless wait_music_method.nil?
        params[:agent_hold_music_url] = agent_hold_music_url unless agent_hold_music_url.nil?
        params[:agent_hold_music_method] = agent_hold_music_method.upcase unless agent_hold_music_method.nil?
        params[:customer_hold_music_url] = customer_hold_music_url unless customer_hold_music_url.nil?
        params[:customer_hold_music_method] = customer_hold_music_method.upcase unless customer_hold_music_method.nil?
        params[:recording_callback_url] = recording_callback_url unless recording_callback_url.nil?
        params[:recording_callback_method] = recording_callback_method.upcase unless recording_callback_method.nil?
        params[:status_callback_url] = status_callback_url unless status_callback_url.nil?
        params[:status_callback_method] = status_callback_method.upcase unless status_callback_method.nil?
        params[:on_exit_action_url] = on_exit_action_url unless on_exit_action_url.nil?
        params[:on_exit_action_method] = on_exit_action_method.upcase unless on_exit_action_method.nil?
        params[:record] = record unless record.nil?
        params[:record_file_format] = record_file_format.downcase unless record_file_format.nil?
        params[:status_callback_events] = status_callback_events.downcase unless status_callback_events.nil?
        params[:stay_alone] = stay_alone unless stay_alone.nil?
        params[:coach_mode] = coach_mode unless coach_mode.nil?
        params[:mute] = mute unless mute.nil?
        params[:hold] = hold unless hold.nil?
        params[:start_mpc_on_enter] = start_mpc_on_enter unless start_mpc_on_enter.nil?
        params[:end_mpc_on_exit] = end_mpc_on_exit unless end_mpc_on_exit.nil?
        params[:relay_dtmf_inputs] = relay_dtmf_inputs unless relay_dtmf_inputs.nil?
        params[:enter_sound] = enter_sound unless enter_sound.nil?
        params[:enter_sound_method] = enter_sound_method.upcase unless exit_sound_method.nil?
        params[:exit_sound] = exit_sound unless exit_sound.nil?
        params[:exit_sound_method] = exit_sound_method.upcase unless exit_sound_method.nil?
        params[:start_recording_audio] = start_recording_audio unless start_recording_audio.nil?
        params[:start_recording_audio_method] = start_recording_audio_method.upcase unless start_recording_audio_method.nil?
        params[:stop_recording_audio] = stop_recording_audio unless stop_recording_audio.nil?
        params[:stop_recording_audio_method] = stop_recording_audio_method.upcase unless stop_recording_audio_method.nil?
        perform_action_apiresponse('Participant', 'POST', params, true )
      end

      def start
        perform_action_apiresponse(nil, 'POST', Hash['status' => 'active'], true)
      end

      def stop
        perform_action_apiresponse(nil, 'DELETE', nil, true)
      end

      def start_recording(file_format = 'mp3', recording_callback_url = nil, recording_callback_method='POST')
        valid_param?(:file_format, file_format, String, false , %w[mp3 wav])
        valid_url?(:recording_callback_url, recording_callback_url, false) unless recording_callback_url.nil?
        valid_param?(:recording_callback_method, recording_callback_method.upcase,String, false, %w[GET POST])

        params = {}
        params[:file_format] = file_format.downcase unless file_format.nil?
        params[:recording_callback_url] = recording_callback_url unless recording_callback_url.nil?
        params[:recording_callback_method] = recording_callback_method.upcase unless recording_callback_method.nil?

        perform_action_apiresponse('Record', 'POST', params, true)
      end

      def stop_recording
        perform_action_apiresponse('Record', 'DELETE')
      end

      def pause_recording
        perform_action_apiresponse('Record/Pause', 'POST')
      end

      def resume_recording
        perform_action_apiresponse('Record/Resume', 'POST')
      end

      def start_participant_recording(member_id, file_format='mp3', recording_callback_url=nil, recording_callback_method='POST')
        valid_param?(:member_id, member_id, [String, Integer], true)
        MultiPartyCallParticipant.new(@_client, resource_id: mpc_id[1], member_id: member_id).start_participant_recording(file_format, recording_callback_url, recording_callback_method)
      end

      def stop_participant_recording(member_id)
        valid_param?(:member_id, member_id, [String, Integer], true)
        MultiPartyCallParticipant.new(@_client, resource_id: mpc_id[1], member_id: member_id).stop_participant_recording
      end

      def pause_participant_recording(member_id)
        valid_param?(:member_id, member_id, [String, Integer], true)
        MultiPartyCallParticipant.new(@_client, resource_id: mpc_id[1], member_id: member_id).pause_participant_recording
      end

      def resume_participant_recording(member_id)
        valid_param?(:member_id, member_id, [String, Integer], true)
        MultiPartyCallParticipant.new(@_client, resource_id: mpc_id[1], member_id: member_id).resume_participant_recording
      end
      
      def list_participants(call_uuid = nil )
        valid_param?(:call_uuid, call_uuid, String, false) unless call_uuid.nil?
        params = {}
        params[:call_uuid] = call_uuid unless call_uuid.nil?
        perform_action('Participant', 'GET', params, true)
      end

      def update_participant(member_id, coach_mode = nil, mute = nil , hold = nil)
        valid_param?(:member_id, member_id, [String, Integer], true)
        MultiPartyCallParticipant.new(@_client, resource_id: @id, member_id: member_id).update_participant(coach_mode, mute, hold)
      end

      def kick_participant(member_id)
        valid_param?(:member_id, member_id, [String, Integer], true)
        MultiPartyCallParticipant.new(@_client, resource_id: @id, member_id: member_id).kick_participant
      end

      def get_participant(member_id)
        valid_param?(:member_id, member_id, [String, Integer], true)
        MultiPartyCallParticipant.new(@_client,resource_id: @id, member_id: member_id).get_participant
      end

      def start_play_audio(member_id, url)
        valid_param?(:member_id, member_id, [String, Integer], true)
        valid_url?(:url, url, true)
        MultiPartyCallMember.new(@_client, resource_id: @id, member_id: member_id).start_play_audio(url)
      end

      def stop_play_audio(member_id)
        valid_param?(:member_id, member_id, [String, Integer], true)
        MultiPartyCallMember.new(@_client, resource_id: @id, member_id: member_id).stop_play_audio
      end
    end

    class MultiPartyCallParticipant < Base::SecondaryResource
      def initialize(client, options = nil)
        @_name = 'MultiPartyCall'
        @_identifier_string = 'mpc_uuid'
        @_secondary_name = 'Participant'
        @_secondary_identifier_string = 'member_id'
        super
        @_is_voice_request = true
        if options.key? :multi_party_prefix
          @id = options[:multi_party_prefix] + '_' + @id
        elsif @id.split('_').size > 1
          nil
        else
          @id = 'uuid_' + @id
        end
        configure_secondary_resource_uri
      end

      def start_participant_recording(file_format = 'mp3', recording_callback_url = nil, recording_callback_method='POST')
        valid_param?(:file_format, file_format, String, false , %w[mp3 wav])
        valid_url?(:recording_callback_url, recording_callback_url, false) unless recording_callback_url.nil?
        valid_param?(:recording_callback_method, recording_callback_method.upcase,String, false, %w[GET POST])

        params = {}
        params[:file_format] = file_format.downcase unless file_format.nil?
        params[:recording_callback_url] = recording_callback_url unless recording_callback_url.nil?
        params[:recording_callback_method] = recording_callback_method.upcase unless recording_callback_method.nil?

        perform_action_apiresponse('Record', 'POST', params, true)
      end

      def stop_participant_recording
        perform_action_apiresponse('Record', 'DELETE')
      end

      def pause_participant_recording
        perform_action_apiresponse('Record/Pause', 'POST')
      end

      def resume_participant_recording
        perform_action_apiresponse('Record/Resume', 'POST')
      end

      def update_participant(coach_mode = nil, mute= nil, hold = nil)
        valid_param?(:coach_mode, coach_mode, [TrueClass, FalseClass], false) unless coach_mode.nil?
        valid_param?(:mute, mute, [TrueClass, FalseClass], false) unless mute.nil?
        valid_param?(:hold, hold, [TrueClass, FalseClass], false) unless hold.nil?
        params = {}
        params[:coach_mode] = coach_mode unless coach_mode.nil?
        params[:mute] = mute unless mute.nil?
        params[:hold] = hold unless hold.nil?
        perform_action_apiresponse(nil, 'POST', params, true )
      end

      def kick_participant
        perform_action_apiresponse(nil, 'DELETE', nil, true)
      end

      def get_participant
        perform_action_apiresponse(nil,'GET',nil,false)
      end
    end

    class MultiPartyCallMember < Base::SecondaryResource
      def initialize(client, options = nil)
        @_name = 'MultiPartyCall'
        @_identifier_string = 'mpc_uuid'
        @_secondary_name = 'Member'
        @_secondary_identifier_string = 'member_id'
        super
        @_is_voice_request = true
        if options.key? :multi_party_prefix
          @id = options[:multi_party_prefix] + '_' + @id
        elsif @id.split('_').size > 1
          nil
        else
          @id = 'uuid_' + @id
        end
        configure_secondary_resource_uri
      end

      def start_play_audio(url)
        valid_url?(:url, url, true)
        params = {}
        params[:url] = url unless url.nil?
        perform_action_apiresponse('Play', 'POST', params, true)
      end

      def stop_play_audio
        perform_action_apiresponse('Play', 'DELETE')
      end
    end

    class MultiPartyCallInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'MultiPartyCall'
        @_resource_type = MultiPartyCall
        @_identifier_string = 'mpc_uuid'
        super
        @_is_voice_request = true
      end

      def make_mpc_id(uuid=nil, friendly_name=nil)
        if not uuid and not friendly_name
          raise_invalid_request('specify either multi party call friendly name or uuid')
        end
        if uuid and friendly_name
          raise_invalid_request('cannot specify both multi party call friendly name or uuid')
        end
        if uuid
          identifier =  ['uuid', uuid]
        else
          identifier = ['name', friendly_name]
        end
        return identifier
      end

      def list(options={})
        valid_param?(:options, options, Hash, false)
        valid_subaccount?(options[:sub_account], true) unless options[:sub_account].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        valid_param?(:status, options[:status].downcase, String, false, %w[initialized active ended]) unless options[:status].nil?
        valid_param?(:termination_cause_code, options[:termination_cause_code], Integer, false) unless options[:termination_cause_code].nil?
        valid_date_format?(:end_time__gt, options[:end_time__gt], false ) unless options[:end_time__gt].nil?
        valid_date_format?(:end_time__gte, options[:end_time__gte], false ) unless options[:end_time__gte].nil?
        valid_date_format?(:end_time__lt, options[:end_time__lt], String) unless options[:end_time__lt].nil?
        valid_date_format?(:end_time__lte, options[:end_time__lte], false) unless options[:end_time__lte].nil?
        valid_date_format?(:creation_time__gt, options[:creation_time__gt], false) unless options[:creation_time__gt].nil?
        valid_date_format?(:creation_time__gte, options[:creation_time__gte], false) unless options[:creation_time__gte].nil?
        valid_date_format?(:creation_time__lt, options[:creation_time__lt], false) unless options[:creation_time__lt].nil?
        valid_date_format?(:creation_time__lte, options[:creation_time__lte], false) unless options[:creation_time__lte].nil?
        valid_range?(:limit, options[:limit], false, 1, 20)
        valid_range?(:offset, options[:offset], false, 0)
        perform_action(nil ,'GET', options ,true )
      end
      
      def get(options = {})
        valid_param?(:options, options, Hash, false)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCall.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0]).get
      end

      def add_participant(options = {})
        valid_param?(:options, options, Hash, false)
        if not options[:role ]
          raise_invalid_request("Role is mandatory")
        end
        options[:call_status_callback_method] = 'POST' unless options.key?(:call_status_callback_method)
        options[:confirm_key_sound_method] = 'GET' unless options.key?(:confirm_key_sound_method)
        options[:dial_music] = 'Real' unless options.key?(:dial_music)
        options[:ring_timeout] = 45 unless options.key?(:ring_timeout) 
        options[:delay_dial] = 0 unless options.key?(:delay_dial)
        options[:max_duration] = 14400 unless options.key?(:max_duration)
        options[:max_participants] = 10 unless options.key?(:max_participants)
        options[:wait_music_method] = 'GET' unless options.key?(:wait_music_method)
        options[:agent_hold_music_method] = 'GET' unless options.key?(:agent_hold_music_method)
        options[:customer_hold_music_method] = 'GET' unless options.key?(:customer_hold_music_method)
        options[:recording_callback_method] ='GET' unless options.key?(:recording_callback_method)
        options[:status_callback_method] = 'GET' unless options.key?(:status_callback_method)
        options[:on_exit_action_method] = 'POST' unless options.key?(:on_exit_action_method)
        options[:record] = false  unless options.key?(:record)
        options[:record_file_format] = 'mp3' unless options.key?(:record_file_format)
        options[:status_callback_events] = 'mpc-state-changes,participant-state-changes' unless options.key?(:status_callback_events)
        options[:stay_alone] = false unless options.key?(:stay_alone)
        options[:coach_mode] = true unless options.key?(:coach_mode)
        options[:mute] = false unless options.key?(:mute)
        options[:hold] = false unless options.key?(:hold)
        options[:start_mpc_on_enter] = true unless options.key?(:start_mpc_on_enter)
        options[:end_mpc_on_exit] = false unless options.key?(:end_mpc_on_exit)
        options[:relay_dtmf_inputs] = false unless options.key?(:relay_dtmf_inputs)
        options[:enter_sound] = 'beep:1' unless options.key?(:enter_sound)
        options[:enter_sound_method] = 'GET' unless options.key?(:enter_sound_method)
        options[:exit_sound] = 'beep:2' unless options.key?(:exit_sound)
        options[:exit_sound_method] = 'GET' unless options.key?(:exit_sound_method)
        options[:start_recording_audio_method] = 'GET' unless options.key?(:start_recording_audio_method)
        options[:stop_recording_audio_method] = 'GET' unless options.key?(:stop_recording_audio_method)
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])

        MultiPartyCall.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0]).add_participant(options[:role],options[:from],options[:to],options[:call_uuid],options[:caller_name],options[:call_status_callback_url],options[:call_status_callback_method],options[:sip_headers],options[:confirm_key],
                                                                          options[:confirm_key_sound_url],options[:confirm_key_sound_method],options[:dial_music],options[:ring_timeout],options[:delay_dial],options[:max_duration], options[:max_participants],options[:wait_music_url],
                                                                          options[:wait_music_method],options[:agent_hold_music_url],options[:agent_hold_music_method],options[:customer_hold_music_url],options[:customer_hold_music_method],
                                                                          options[:recording_callback_url],options[:recording_callback_method],options[:status_callback_url],options[:status_callback_method],options[:on_exit_action_url], options[:on_exit_action_method],
                                                                          options[:record],options[:record_file_format],options[:status_callback_events],options[:stay_alone], options[:coach_mode],options[:mute],options[:hold],options[:start_mpc_on_enter],options[:end_mpc_on_exit],
                                                                          options[:relay_dtmf_inputs],options[:enter_sound],options[:enter_sound_method],options[:exit_sound],options[:exit_sound_method], options[:start_recording_audio], options[:start_recording_audio_method],
                                                                                                            options[:stop_recording_audio], options[:stop_recording_audio_method])
      end

      def start(options = {})
        valid_param?(:options, options, Hash, false)
        valid_param?(:uuid, options[:uuid], String, false)
        valid_param?(:friendly_name, options[:friendly_name], String, false)
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCall.new(@_client,resource_id: mpc_id[1], multi_party_prefix: mpc_id[0]).start
      end

      def stop(options = {})
        valid_param?(:options, options, Hash, false)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCall.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0]).stop
      end

      def start_recording(options = {})
        valid_param?(:options, options, Hash, false)
        options[:file_format] = 'mp3' unless options.key?(:file_format)
        options[:recording_callback_method] = 'POST' unless options.key?(:recording_callback_method)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCall.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0]).start_recording(options[:file_format], options[:recording_callback_url], options[:recording_callback_method])
      end

      def stop_recording(options = {})
        valid_param?(:options, options, Hash, false)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCall.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0]).stop_recording
      end

      def pause_recording(options = {})
        valid_param?(:options, options, Hash, false)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCall.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0]).pause_recording
      end

      def resume_recording(options = {})
        valid_param?(:options, options, Hash, false)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCall.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0]).resume_recording
      end

      def start_participant_recording(options = {})
        valid_param?(:options, options, Hash, false)
        if not options[:member_id]
          raise_invalid_request("Member Id is mandatory")
        end
        options[:file_format] = 'mp3' unless options.key?(:file_format)
        options[:recording_callback_method] = 'POST' unless options.key?(:recording_callback_method)
        valid_param?(:member_id, options[:member_id], [String, Integer], true)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCallParticipant.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0], member_id: options[:member_id]).start_participant_recording(options[:file_format], options[:recording_callback_url], options[:recording_callback_method])
      end

      def stop_participant_recording(options = {})
        valid_param?(:options, options, Hash, false)
        if not options[:member_id]
          raise_invalid_request("Member Id is mandatory")
        end
        valid_param?(:member_id, options[:member_id], [String, Integer], true)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCallParticipant.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0], member_id: options[:member_id]).stop_participant_recording
      end

      def pause_participant_recording(options = {})
        valid_param?(:options, options, Hash, false)
        if not options[:member_id]
          raise_invalid_request("Member Id is mandatory")
        end
        valid_param?(:member_id, options[:member_id], [String, Integer], true)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCallParticipant.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0], member_id: options[:member_id]).pause_participant_recording
      end

      def resume_participant_recording(options = {})
        valid_param?(:options, options, Hash, false)
        if not options[:member_id]
          raise_invalid_request("Member Id is mandatory")
        end
        valid_param?(:member_id, options[:member_id], [String, Integer], true)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCallParticipant.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0], member_id: options[:member_id]).resume_participant_recording
      end
      
      def list_participants(options = {})
        valid_param?(:options, options, Hash, false)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCall.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0]).list_participants(options[:call_uuid])
      end

      def update_participant(options =  {})
        valid_param?(:options, options, Hash, false)
        if not options[:member_id]
          raise_invalid_request("Member Id is mandatory")
        end
        valid_param?(:member_id, options[:member_id], [String, Integer], true)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = self.make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCallParticipant.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0], member_id: options[:member_id]).update_participant(options[:coach_mode], options[:mute], options[:hold])
      end

      def kick_participant(options = {})
        valid_param?(:options, options, Hash, false)
        if not options[:member_id]
          raise_invalid_request("Member Id is mandatory")
        end
        valid_param?(:member_id, options[:member_id], [String, Integer], true)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCallParticipant.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0], member_id: options[:member_id]).kick_participant
      end

      def get_participant(options = {})
        valid_param?(:options, options, Hash, false)
        if not options[:member_id]
          raise_invalid_request("Member Id is mandatory")
        end
        valid_param?(:member_id, options[:member_id], [String, Integer], true)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCallParticipant.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0], member_id: options[:member_id]).get_participant
      end

      def start_play_audio(options = {})
        valid_param?(:options, options, Hash, false)
        if not options[:member_id]
          raise_invalid_request("Member Id is mandatory")
        end
        valid_param?(:member_id, options[:member_id], [String, Integer], true)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCallMember.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0], member_id: options[:member_id]).start_play_audio(options[:url])
      end

      def stop_play_audio(options = {})
        valid_param?(:options, options, Hash, false)
        if not options[:member_id]
          raise_invalid_request("Member Id is mandatory")
        end
        valid_param?(:member_id, options[:member_id], [String, Integer], true)
        valid_param?(:uuid, options[:uuid], String, false) unless options[:uuid].nil?
        valid_param?(:friendly_name, options[:friendly_name], String, false) unless options[:friendly_name].nil?
        mpc_id = make_mpc_id(options[:uuid], options[:friendly_name])
        MultiPartyCallMember.new(@_client, resource_id: mpc_id[1], multi_party_prefix: mpc_id[0], member_id: options[:member_id]).stop_play_audio
      end
    end
  end
end