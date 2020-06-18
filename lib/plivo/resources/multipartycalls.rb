module Plivo
  module Resources
    include Plivo::Utils
    class MultiPartyCall < Base::Resource
      def initialize(client, options = nil)
        @_name = 'MultiPartyCall'
        @_identifier_string = 'mpc_uuid'
        super
      end

      def add_participant
        perform_action('Participant', 'POST')
      end

      def start(status_hash)
        valid_param?(:statusHash, status_hash, Hash, true, Hash['status' => 'active'])
        perform_action(nil, 'POST', status_hash, true)
      end

      def stop
        perform_delete
      end

      def start_recording(file_format, status_callback_url, status_callback_method)
        params = Hash[:file_format => file_format, :status_callback_url => status_callback_url, :status_callback_method => status_callback_method]
        perform_action('Record', 'POST', params, true)
      end

      def stop_recording
        perform_action('Record', 'DELETE')
      end

      def pause_recording
        perform_action('Record/Pause', 'POST')
      end

      def resume_recording
        perform_action('Record/Resume', 'POST')
      end

      def list_participants
        perform_action('Participant', 'GET')
      end

      def update_participant(participant_id, coach_mode, mute, hold)
        params = Hash[:participant_id => participant_id, :coach_mode => coach_mode, :mute => mute, :hold => hold]
        perform_action('Participant/' + participant_id.to_s, 'POST', params, true)
      end

      def kick_participant(participant_id)
        valid_param?(:participant_id, participant_id, [String, Integer], true)
        perform_action('Participant/' + participant_id.to_s, 'DELETE', nil, true)
      end

      def get_participant(participant_id)
        valid_param?(:participant_id, participant_id, [String, Integer], true)
        perform_action('Participant/' + participant_id.to_s, 'GET', nil, true)
      end
    end

    class MultiPartyCallInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'MultiPartyCall'
        @_resource_type = MultiPartyCall
        @_identifier_string = 'mpc_uuid'
        super
      end

      def make_mpc_id(uuid=nil, friendly_name=nil)
        if not uuid and not friendly_name
          raise_invalid_request('specify either multi party call friendly name or uuid')
        end
        if uuid and friendly_name
          raise_invalid_request('cannot specify both multi party call friendly name or uuid')
        end
        if uuid
          mpc_id = 'uuid_' + uuid.to_s
        else
          mpc_id = 'name_' + friendly_name.to_s
        end
        return mpc_id
      end

      def list(sub_account=nil,
               friendly_name=nil,
               status=nil,
               termination_cause_code=nil,
               end_time__gt=nil,
               end_time__gte=nil,
               end_time__lt=nil,
               end_time__lte=nil,
               creation_time__gt=nil,
               creation_time__gte=nil,
               creation_time__lt=nil,
               creation_time__lte=nil,
               limit=nil,
               offset=nil)
        valid_subaccount?(sub_account, true)
        valid_param?(:friendly_name, friendly_name, String, false)
        valid_param?(:status, status, String, false, %w[Initialized Active Ended])
        valid_param?(:termination_cause_code, termination_cause_code, Integer, false)
        valid_param?(:end_time__gt, end_time__gt, String, false )
        valid_param?(:end_time__gte, end_time__gte, String, false )
        valid_param?(:end_time__lt, end_time__lt, String, false )
        valid_param?(:end_time__lt, end_time__lte, String, false )
        valid_param?(:creation_time__gt, creation_time__gt, String, false )
        valid_param?(:creation_time__gte, creation_time__gte, String, false )
        valid_param?(:creation_time__lt, creation_time__lt, String, false )
        valid_param?(:creation_time__lte, creation_time__lte, String, false )
        valid_param?(:limit, limit, Integer, false, lambda {|limit| 0<limit<=20})
        valid_param?(:offset, offset, Integer, false, lambda {|offset| 0<=offset})
        perform_list_without_object
        {
            api_id: @api_id,
            multipartycalls: @multipartycalls
        }
      end

      def each
        mpc_list = list
        mpc_list[:multipartycalls].each { |mpc| yield mpc }
      end
      
      def get(uuid = nil, friendly_name = nil)
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:friendly_name, friendly_name, String, false)
        mpc_id = make_mpc_id(uuid, friendly_name)
        perform_get(mpc_id)
      end

      def add_participant(role,
                          friendly_name = nil,
                          uuid=nil,
                          from_=nil,
                          to_=nil,
                          call_uuid=nil,
                          call_status_callback_url=nil,
                          call_status_callback_method='POST',
                          sip_headers=nil,
                          confirm_key=nil,
                          confirm_key_sound_url=nil,
                          confirm_key_sound_method='GET',
                          dial_music='Real',
                          ring_timeout=45,
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
                          start_mpc_on_enter=true,
                          end_mpc_on_exit=false,
                          relay_dtmf_inputs=false,
                          enter_sound='beep:1',
                          enter_sound_method='GET',
                          exit_sound='beep:2',
                          exit_sound_method='GET')
        valid_param?(:role, role, String, true, %w[Agent Supervisor Customer])
        valid_param?(:friendly_name, friendly_name, String, false)
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:from_, from_, String, false )
        valid_param?(:to_, to_, String, false )
        valid_param?(:call_uuid, call_uuid, String, false )
        valid_param?(:call_status_callback_url, call_status_callback_url, String, false)
        valid_param?(:call_status_callback_method, call_status_callback_method, String, false, %w[GET POST])
        valid_param?(:sip_headers, sip_headers, String, false)
        valid_param?(:confirm_key, confirm_key, String, false , %w[0 1 2 3 4 5 6 7 8 9 # *])
        valid_param?(:confirm_key_sound_url, confirm_key_sound_url, String, false )
        valid_param?(:confirm_key_sound_method, confirm_key_sound_method, String, false, %w[GET POST])
        valid_param?(:dial_music, dial_music, String, false)
        valid_param?(:ring_timeout, ring_timeout, Integer, false, lambda {|ring_timeout| 15<=ring_timeout<=120})
        valid_param?(:max_duration, max_duration, Integer, false, lambda {|max_duration| 300<=max_duration<=28800})
        valid_param?(:max_participants, max_participants, Integer, false, lambda {|max_participants| 2<=max_participants<=10})
        valid_param?(:wait_music_url, wait_music_url, String, false )
        valid_param?(:wait_music_method, wait_music_method, String, false , %w[GET POST])
        valid_param?(:agent_hold_music_url, agent_hold_music_url, String, false )
        valid_param?(:agent_hold_music_method, agent_hold_music_method, String, false , %w[GET POST])
        valid_param?(:customer_hold_music_url, customer_hold_music_url, String, false)
        valid_param?(:customer_hold_music_method, customer_hold_music_method, String, false, %w[GET POST])
        valid_param?(:recording_callback_url, recording_callback_url, String, false)
        valid_param?(:recording_callback_method, recording_callback_method, String, false, %w[GET POST])
        valid_param?(:status_callback_url, status_callback_url, String, false)
        valid_param?(:status_callback_method, status_callback_method, String, false, %w[GET POST])
        valid_param?(:on_exit_action_url, on_exit_action_url, String, false)
        valid_param?(:on_exit_action_method, on_exit_action_method, String, false, %w[GET POST])
          valid_param?(:record, record, [TrueClass, FalseClass], false )
        valid_param?(:record_file_format, record_file_format, String, false, %w[mp3 wav])
        valid_param?(:status_callback_events, status_callback_events, String, false, %w[mpc-state-changes participant-state-changes participant-speak-events])
        valid_param?(:stay_alone, stay_alone, [TrueClass, FalseClass], false)
        valid_param?(:coach_mode, coach_mode, [TrueClass, FalseClass], false)
        valid_param?(:mute, mute, [TrueClass, FalseClass],false)
        valid_param?(:hold, hold, [TrueClass, FalseClass], false)
        valid_param?(:start_mpc_on_enter, start_mpc_on_enter, [TrueClass, FalseClass], false)
        valid_param?(:end_mpc_on_exit, end_mpc_on_exit, [TrueClass, FalseClass], false)
        valid_param?(:relay_dtmf_inputs, relay_dtmf_inputs, [TrueClass, FalseClass], false)
        valid_param?(:enter_sound, enter_sound, String, false)
        valid_param?(:enter_sound_method, enter_sound_method, String, false, %w[GET POST])
        valid_param?(:exit_sound, exit_sound, String, false)
        valid_param?(:exit_sound_method, exit_sound_method, String, false, %w[GET POST])

        mpc_id = make_mpc_id(uuid, friendly_name)
        if (from_ and to_) and call_uuid
          raise_invalid_request('cannot specify call_uuid when (from, to) is provided')
        end
        if not from_ and not to_ and not call_uuid
          raise_invalid_request('specify either call_uuid or (from, to)')
        end
        if call_uuid.nil? and (not from_ or not to_)
          raise_invalid_request('specify (from, to) when not adding an existing call_uuid to multi party participant')
        end
        MultiPartyCall.new(@_client, resource_id: mpc_id).add_participant
      end

      def start(uuid = nil, friendly_name = nil)
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:friendly_name, friendly_name, String, false)
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).start(Hash['status' => 'active'])
      end

      def stop(uuid = nil, friendly_name = nil)
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:friendly_name, friendly_name, String, false)
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).stop
      end

      def start_recording(uuid = nil, friendly_name = nil, file_format='mp3', status_callback_url=None, status_callback_method='POST')
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:friendly_name, friendly_name, String, false)
        valid_param?(:file_format, file_format, String, false , %w[mp3 wav])
        valid_param?(:status_callback_url, status_callback_url, String, false)
        valid_param?(:status_callback_method, status_callback_method,String, false, %w[GET POST])
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).start_recording(file_format, status_callback_url, status_callback_method)
      end

      def stop_recording(uuid = nil, friendly_name = nil)
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:friendly_name, friendly_name, String, false)
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).stop_recording
      end

      def pause_recording(uuid = nil, friendly_name = nil)
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:friendly_name, friendly_name, String, false)
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).pause_recording
      end

      def resume_recording(uuid = nil, friendly_name = nil)
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:friendly_name, friendly_name, String, false)
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).resume_recording
      end

      def list_participants(uuid = nil, friendly_name = nil, call_uuid = nil)
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:friendly_name, friendly_name, String, false)
        valid_param?(:call_uuid, call_uuid, String, false)
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).list_participants
      end

      def update_participant(participant_id, uuid=nil, friendly_name=nil, coach_mode=nil, mute=nil, hold=nil)
        valid_param?(:participant_id, participant_id, [String, Integer], true)
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:friendly_name, friendly_name, String, false)
        valid_param?(:coach_mode, coach_mode, [TrueClass, FalseClass], false)
        valid_param?(:mute, mute, [TrueClass, FalseClass], false)
        valid_param?(:hold, hold, [TrueClass, FalseClass], false)
        mpc_id = self.__make_mpc_id(friendly_name, uuid)
        MultiPartyCall.new(@_client, resource_id: mpc_id).update_participant(participant_id, coach_mode, mute, hold)
      end

      def kick_participant(participant_id, uuid = nil, friendly_name = nil)
        valid_param?(:participant_id, participant_id, [String, Integer], true)
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:friendly_name, friendly_name, String, false)
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).kick_participant(participant_id)
      end

      def get_participant(participant_id, uuid = nil, friendly_name = nil)
        valid_param?(:participant_id, participant_id, [String, Integer], true)
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:friendly_name, friendly_name, String, false)
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).get_participant(participant_id)
      end
    end
  end
end