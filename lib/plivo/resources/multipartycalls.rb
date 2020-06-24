module Plivo
  module Resources
    include Plivo::Utils
    class MultiPartyCall < Base::Resource
      def initialize(client, options = nil)
        @_name = 'MultiPartyCall'
        @_identifier_string = 'mpc_uuid'
        super
      end

      def add_participant(role,friendly_name,uuid,from,to,call_uuid,call_status_callback_url,call_status_callback_method,sip_headers,confirm_key,
              confirm_key_sound_url,confirm_key_sound_method,dial_music, ring_timeout,max_duration, max_participants,wait_music_url,
              wait_music_method,agent_hold_music_url,agent_hold_music_method,customer_hold_music_url,customer_hold_music_method,
              recording_callback_url,recording_callback_method,status_callback_url,status_callback_method,on_exit_action_url, on_exit_action_method,
              record,record_file_format,status_callback_events,stay_alone, coach_mode,mute,hold,start_mpc_on_enter,end_mpc_on_exit,
              relay_dtmf_inputs,enter_sound,enter_sound_method,exit_sound,exit_sound_method)
        params = {}
        params[:role] = role unless role.nil?
        params[:friendly_name] = friendly_name unless friendly_name.nil?
        params[:uuid] = uuid unless uuid.nil?
        params[:from] = from unless from.nil?
        params[:to] = to unless to.nil?
        params[:call_uuid] = call_uuid unless call_uuid.nil?
        params[:call_status_callback_url] = call_status_callback_url unless call_status_callback_url.nil?
        params[:call_status_callback_method] = call_status_callback_method unless call_status_callback_method.nil?
        params[:sip_headers] = sip_headers unless sip_headers.nil?
        params[:confirm_key] = confirm_key unless confirm_key.nil?
        params[:confirm_key_sound_url] = confirm_key_sound_url unless confirm_key_sound_url.nil?
        params[:confirm_key_sound_method] = confirm_key_sound_method unless confirm_key_sound_method.nil?
        params[:dial_music] = dial_music unless dial_music.nil?
        params[:ring_timeout] = ring_timeout unless ring_timeout.nil?
        params[:max_duration] = max_duration unless max_duration.nil?
        params[:max_participants] = max_participants unless max_participants.nil?
        params[:wait_music_url] = wait_music_url unless wait_music_url.nil?
        params[:wait_music_method] = wait_music_method unless wait_music_method.nil?
        params[:agent_hold_music_url] = agent_hold_music_url unless agent_hold_music_url.nil?
        params[:agent_hold_music_method] = agent_hold_music_method unless agent_hold_music_method.nil?
        params[:customer_hold_music_url] = customer_hold_music_url unless customer_hold_music_url.nil?
        params[:customer_hold_music_method] = customer_hold_music_method unless customer_hold_music_method.nil?
        params[:recording_callback_url] = recording_callback_url unless recording_callback_url.nil?
        params[:recording_callback_method] = recording_callback_method unless recording_callback_method.nil?
        params[:status_callback_url] = status_callback_url unless status_callback_url.nil?
        params[:status_callback_method] = status_callback_method unless status_callback_method.nil?
        params[:on_exit_action_url] = on_exit_action_url unless on_exit_action_url.nil?
        params[:on_exit_action_method] = on_exit_action_method unless on_exit_action_method.nil?
        params[:record] = record unless record.nil?
        params[:record_file_format] = record_file_format unless record_file_format.nil?
        params[:status_callback_events] = status_callback_events unless status_callback_events.nil?
        params[:stay_alone] = stay_alone unless stay_alone.nil?
        params[:coach_mode] = coach_mode unless coach_mode.nil?
        params[:mute] = mute unless mute.nil?
        params[:hold] = hold unless hold.nil?
        params[:start_mpc_on_enter] = start_mpc_on_enter unless start_mpc_on_enter.nil?
        params[:end_mpc_on_exit] = end_mpc_on_exit unless end_mpc_on_exit.nil?
        params[:relay_dtmf_inputs] = relay_dtmf_inputs unless relay_dtmf_inputs.nil?
        params[:enter_sound] = enter_sound unless enter_sound.nil?
        params[:enter_sound_method] = enter_sound_method unless exit_sound_method.nil?
        params[:exit_sound] = exit_sound unless exit_sound.nil?
        params[:exit_sound_method] = exit_sound_method unless exit_sound_method.nil?
        perform_action('Participant', 'POST', params, true )
      end

      def start(status_hash)
        valid_param?(:statusHash, status_hash, Hash, true, Hash['status' => 'active'])
        perform_action(nil, 'POST', status_hash, true)
      end

      def stop
        perform_delete
      end

      def start_recording(file_format, status_callback_url, status_callback_method)
        params = {}
        params[:file_format] = file_format unless file_format.nil?
        params[:status_callback_url] = status_callback_url unless status_callback_url.nil?
        params[:status_callback_method] = status_callback_method unless status_callback_method.nil?
        # params = Hash[:file_format => file_format, :status_callback_url => status_callback_url, :status_callback_method => status_callback_method]
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
        params = {}
        params[:coach_mode] = coach_mode unless coach_mode.nil?
        params[:mute] = mute unless mute.nil?
        params[:hold] = hold unless hold.nil?
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
        params = {}
        valid_subaccount?(sub_account, true) unless sub_account.nil?
        params[:sub_account] = sub_account unless sub_account.nil?
        valid_param?(:friendly_name, friendly_name, String, false) unless friendly_name.nil?
        params[:friendly_name] = friendly_name unless friendly_name.nil?
        valid_param?(:status, status.downcase, String, false, %w[initialized active ended]) unless status.nil?
        params[:status] = status unless status.nil?
        valid_param?(:termination_cause_code, termination_cause_code, Integer, false) unless termination_cause_code.nil?
        params[:termination_cause_code] = termination_cause_code unless termination_cause_code.nil?
        valid_param?(:end_time__gt, end_time__gt, String, false ) unless end_time__gt.nil?
        params[:end_time__gt] = end_time__gt unless end_time__gt.nil?
        valid_param?(:end_time__gte, end_time__gte, String, false ) unless end_time__gte.nil?
        params[:end_time__gte] = end_time__gte unless end_time__gte.nil?
        valid_param?(:end_time__lt, end_time__lt, String, false ) unless end_time__lt.nil?
        params[:end_time__lt] = end_time__lt unless end_time__lt.nil?
        valid_param?(:end_time__lt, end_time__lte, String, false ) unless end_time__lte.nil?
        params[:end_time__lte] = end_time__lte unless end_time__lte.nil?
        valid_param?(:creation_time__gt, creation_time__gt, String, false ) unless creation_time__gt.nil?
        params[:creation_time__gt] = creation_time__gt unless creation_time__gt.nil?
        valid_param?(:creation_time__gte, creation_time__gte, String, false ) unless creation_time__gte.nil?
        params[:creation_time__gte] = creation_time__gte unless creation_time__gte.nil?
        valid_param?(:creation_time__lt, creation_time__lt, String, false ) unless creation_time__lt.nil?
        params[:creation_time__lt] = creation_time__lt unless creation_time__lt.nil?
        valid_param?(:creation_time__lte, creation_time__lte, String, false ) unless creation_time__lte.nil?
        params[:creation_time__lte] = creation_time__lte unless creation_time__lte.nil?
        valid_param?(:limit, limit, Integer, false, (1..20).to_a) unless limit.nil?
        params[:limit] = limit unless limit.nil?
        valid_param?(:offset, offset, Integer, false, (0..Float::INFINITY).to_a) unless offset.nil?
        params[:offset] = offset unless offset.nil?
        perform_action(nil ,'GET', params ,true)
      end
      
      def get(uuid = nil, friendly_name = nil)
        valid_param?(:uuid, uuid, String, false) unless uuid.nil?
        valid_param?(:friendly_name, friendly_name, String, false) unless friendly_name.nil?
        mpc_id = make_mpc_id(uuid, friendly_name)
        perform_get(mpc_id)
      end

      def add_participant(role,
                          friendly_name = nil,
                          uuid=nil,
                          from=nil,
                          to=nil,
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
                          start_mpc_on_enter=false,
                          end_mpc_on_exit=false,
                          relay_dtmf_inputs=false,
                          enter_sound='beep:1',
                          enter_sound_method='GET',
                          exit_sound='beep:2',
                          exit_sound_method='GET')
        valid_param?(:role, role.downcase, String, true, %w[agent supervisor customer])
        valid_param?(:friendly_name, friendly_name, String, false) unless friendly_name.nil?
        valid_param?(:uuid, uuid, String, false) unless uuid.nil?
        valid_param?(:from, from, String, false ) unless from.nil?
        valid_param?(:to, to, String, false ) unless to.nil?
        valid_param?(:call_uuid, call_uuid, String, false ) unless call_uuid.nil?
        valid_param?(:call_status_callback_url, call_status_callback_url, String, false) unless call_status_callback_url.nil?
        valid_param?(:call_status_callback_method, call_status_callback_method, String, false, %w[GET POST])
        valid_param?(:sip_headers, sip_headers, String, false) unless sip_headers.nil?
        valid_param?(:confirm_key, confirm_key, String, false , %w[0 1 2 3 4 5 6 7 8 9 # *]) unless confirm_key.nil?
        valid_param?(:confirm_key_sound_url, confirm_key_sound_url, String, false ) unless confirm_key_sound_url.nil?
        valid_param?(:confirm_key_sound_method, confirm_key_sound_method, String, false, %w[GET POST])
        valid_param?(:dial_music, dial_music, String, false)
        valid_param?(:ring_timeout, ring_timeout, Integer, false, (15..120).to_a)
        valid_param?(:max_duration, max_duration, Integer, false, (300..28800).to_a)
        valid_param?(:max_participants, max_participants, Integer, false, (2..10).to_a)
        valid_param?(:wait_music_url, wait_music_url, String, false ) unless wait_music_url.nil?
        valid_param?(:wait_music_method, wait_music_method, String, false , %w[GET POST])
        valid_param?(:agent_hold_music_url, agent_hold_music_url, String, false ) unless agent_hold_music_url.nil?
        valid_param?(:agent_hold_music_method, agent_hold_music_method, String, false , %w[GET POST])
        valid_param?(:customer_hold_music_url, customer_hold_music_url, String, false) unless customer_hold_music_url.nil?
        valid_param?(:customer_hold_music_method, customer_hold_music_method, String, false, %w[GET POST])
        valid_param?(:recording_callback_url, recording_callback_url, String, false) unless recording_callback_url.nil?
        valid_param?(:recording_callback_method, recording_callback_method, String, false, %w[GET POST])
        valid_param?(:status_callback_url, status_callback_url, String, false) unless status_callback_url.nil?
        valid_param?(:status_callback_method, status_callback_method, String, false, %w[GET POST])
        valid_param?(:on_exit_action_url, on_exit_action_url, String, false) unless on_exit_action_url.nil?
        valid_param?(:on_exit_action_method, on_exit_action_method, String, false, %w[GET POST])
        valid_param?(:record, record, [TrueClass, FalseClass], false )
        valid_param?(:record_file_format, record_file_format, String, false, %w[mp3 wav])
        valid_param?(:status_callback_events, status_callback_events, String, false)
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
        if (from and to) and call_uuid
          raise_invalid_request('cannot specify call_uuid when (from, to) is provided')
        end
        if not from and not to and not call_uuid
          raise_invalid_request('specify either call_uuid or (from, to)')
        end
        if call_uuid.nil? and (not from or not to)
          raise_invalid_request('specify (from, to) when not adding an existing call_uuid to multi party participant')
        end
        MultiPartyCall.new(@_client, resource_id: mpc_id).add_participant(role,friendly_name,uuid,from,to,call_uuid,call_status_callback_url,call_status_callback_method,sip_headers,confirm_key,
                                                                          confirm_key_sound_url,confirm_key_sound_method,dial_music, ring_timeout,max_duration, max_participants,wait_music_url,
                                                                          wait_music_method,agent_hold_music_url,agent_hold_music_method,customer_hold_music_url,customer_hold_music_method,
                                                                          recording_callback_url,recording_callback_method,status_callback_url,status_callback_method,on_exit_action_url, on_exit_action_method,
                                                                          record,record_file_format,status_callback_events,stay_alone, coach_mode,mute,hold,start_mpc_on_enter,end_mpc_on_exit,
                                                                          relay_dtmf_inputs,enter_sound,enter_sound_method,exit_sound,exit_sound_method)
      end

      def start(uuid = nil, friendly_name = nil)
        valid_param?(:uuid, uuid, String, false)
        valid_param?(:friendly_name, friendly_name, String, false)
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).start(Hash['status' => 'active'])
      end

      def stop(uuid = nil, friendly_name = nil)
        valid_param?(:uuid, uuid, String, false) unless uuid.nil?
        valid_param?(:friendly_name, friendly_name, String, false) unless friendly_name.nil?
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).stop
      end

      def start_recording(uuid = nil, friendly_name = nil, file_format='mp3', status_callback_url=nil, status_callback_method='POST')
        valid_param?(:uuid, uuid, String, false) unless uuid.nil?
        valid_param?(:friendly_name, friendly_name, String, false) unless friendly_name.nil?
        valid_param?(:file_format, file_format, String, false , %w[mp3 wav])
        valid_param?(:status_callback_url, status_callback_url, String, false) unless status_callback_url.nil?
        valid_param?(:status_callback_method, status_callback_method,String, false, %w[GET POST])
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).start_recording(file_format, status_callback_url, status_callback_method)
      end

      def stop_recording(uuid = nil, friendly_name = nil)
        valid_param?(:uuid, uuid, String, false) unless uuid.nil?
        valid_param?(:friendly_name, friendly_name, String, false) unless friendly_name.nil?
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).stop_recording
      end

      def pause_recording(uuid = nil, friendly_name = nil)
        valid_param?(:uuid, uuid, String, false) unless uuid.nil?
        valid_param?(:friendly_name, friendly_name, String, false) unless friendly_name.nil?
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).pause_recording
      end

      def resume_recording(uuid = nil, friendly_name = nil)
        valid_param?(:uuid, uuid, String, false) unless uuid.nil?
        valid_param?(:friendly_name, friendly_name, String, false) unless friendly_name.nil?
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).resume_recording
      end

      def list_participants(uuid = nil, friendly_name = nil, call_uuid = nil)
        valid_param?(:uuid, uuid, String, false) unless uuid.nil?
        valid_param?(:friendly_name, friendly_name, String, false) unless friendly_name.nil?
        valid_param?(:call_uuid, call_uuid, String, false) unless call_uuid.nil?
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).list_participants
      end

      def update_participant(participant_id, uuid=nil, friendly_name=nil, coach_mode=nil, mute=nil, hold=nil)
        valid_param?(:participant_id, participant_id, [String, Integer], true)
        valid_param?(:uuid, uuid, String, false) unless uuid.nil?
        valid_param?(:friendly_name, friendly_name, String, false) unless friendly_name.nil?
        valid_param?(:coach_mode, coach_mode, [TrueClass, FalseClass], false) unless coach_mode.nil?
        valid_param?(:mute, mute, [TrueClass, FalseClass], false) unless mute.nil?
        valid_param?(:hold, hold, [TrueClass, FalseClass], false) unless hold.nil?
        mpc_id = self.make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).update_participant(participant_id, coach_mode, mute, hold)
      end

      def kick_participant(participant_id, uuid = nil, friendly_name = nil)
        valid_param?(:participant_id, participant_id, [String, Integer], true)
        valid_param?(:uuid, uuid, String, false) unless uuid.nil?
        valid_param?(:friendly_name, friendly_name, String, false) unless friendly_name.nil?
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).kick_participant(participant_id)
      end

      def get_participant(participant_id, uuid = nil, friendly_name = nil)
        valid_param?(:participant_id, participant_id, [String, Integer], true)
        valid_param?(:uuid, uuid, String, false) unless uuid.nil?
        valid_param?(:friendly_name, friendly_name, String, false) unless friendly_name.nil?
        mpc_id = make_mpc_id(uuid, friendly_name)
        MultiPartyCall.new(@_client, resource_id: mpc_id).get_participant(participant_id)
      end
    end
  end
end