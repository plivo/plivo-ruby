module Plivo
  module XML
    class MultiPartyCall < Element
      @nestables = []
      @valid_attributes = %w[role maxDuration maxParticipants waitMusicUrl
                             waitMusicMethod agentHoldMusicUrl agentHoldMusicMethod
                             customerHoldMusicUrl customerHoldMusicMethod record
                             recordFileFormat recordingCallbackUrl recordingCallbackMethod
                             statusCallbackEvents statusCallbackUrl statusCallbackMethod
                             stayAlone coachMode mute hold startMpcOnEnter endMpcOnExit
                             enterSound enterSoundMethod exitSound exitSoundMethod
                             onExitActionUrl onExitActionMethod relayDTMFInputs]

      VALID_ROLE_VALUES = %w[agent supervisor customer]
      VALID_MAX_DURATION_VALUES = (300..28800).to_a
      VALID_MAX_PARTICIPANT_VALUES = (2..10).to_a
      VALID_WAIT_MUSIC_METHOD_VALUES = %w[GET POST]
      VALID_AGENT_HOLD_MUSIC_METHOD_VALUES = %w[GET POST]
      VALID_CUSTOMER_HOLD_MUSIC_METHOD_VALUES = %w[GET POST]
      VALID_RECORD_VALUES = [true, false]
      VALID_RECORD_FILE_FORMAT_VALUES = %w[mp3 wav]
      VALID_RECORDING_CALLBACK_METHOD_VALUES = %w[GET POST]
      VALID_STATUS_CALLBACK_METHOD_VALUES = %w[GET POST]
      VALID_STAY_ALONE_VALUES = [true, false]
      VALID_COACH_MODE_VALUES = [true, false]
      VALID_MUTE_VALUES = [true, false]
      VALID_HOLD_VALUES = [true, false]
      VALID_START_MPC_ON_ENTER_VALUES = [true, false ]
      VALID_END_MPC_ON_EXIT_VALUES = [true, false ]
      VALID_ENTER_SOUND_METHOD_VALUES = %w[GET POST]
      VALID_EXIT_SOUND_METHOD_VALUES = %w[GET POST]
      VALID_ON_EXIT_ACTION_METHOD_VALUES = %w[GET POST]
      VALID_RELAY_DTMF_INPUTS_VALUES = [true, false ]
      

      def initialize(body, attributes = {})
        if attributes[:role] && !VALID_ROLE_VALUES.include?(attributes[:role].downcase)
          raise PlivoXMLError, "invalid attribute value #{attributes[:role]} for maxDuration"
        elsif !attributes[:role]
          raise PlivoXMLError, "role not mentioned : possible values - Agent / Supervisor / Customer"
        end

        if attributes[:maxDuration] && !VALID_MAX_DURATION_VALUES.include?(attributes[:maxDuration])
          raise PlivoXMLError, "invalid attribute value #{attributes[:maxDuration]} for maxDuration"
        elsif !attributes[:maxDuration]
          attributes[:maxDuration] = 14400
        end

        if attributes[:maxParticipants] && !VALID_MAX_PARTICIPANT_VALUES.include?(attributes[:maxParticipants])
          raise PlivoXMLError, "invalid attribute value #{attributes[:maxParticipants]} for maxParticipants"
        elsif !attributes[:maxParticipants]
          attributes[:maxParticipants] = 10
        end

        if attributes[:waitMusicMethod] && !VALID_WAIT_MUSIC_METHOD_VALUES.include?(attributes[:waitMusicMethod])
          raise PlivoXMLError, "invalid attribute value #{attributes[:waitMusicMethod]} for waitMusicMethod"
        elsif !attributes[:waitMusicMethod]
          attributes[:waitMusicMethod] = 'GET'
        end

        if attributes[:agentHoldMusicMethod] && !VALID_AGENT_HOLD_MUSIC_METHOD_VALUES.include?(attributes[:agentHoldMusicMethod])
          raise PlivoXMLError, "invalid attribute value #{attributes[:agentHoldMusicMethod]} for agentHoldMusicMethod"
        elsif !attributes[:agentHoldMusicMethod]
          attributes[:agentHoldMusicMethod] = 'GET'
        end

        if attributes[:customerHoldMusicMethod] && !VALID_CUSTOMER_HOLD_MUSIC_METHOD_VALUES.include?(attributes[:customerHoldMusicMethod])
          raise PlivoXMLError, "invalid attribute value #{attributes[:customerHoldMusicMethod]} for customerHoldMusicMethod"
        elsif !attributes[:customerHoldMusicMethod]
          attributes[:customerHoldMusicMethod] = 'GET'
        end

        if attributes[:record] && !VALID_RECORD_VALUES.include?(attributes[:record])
          raise PlivoXMLError, "invalid attribute value #{attributes[:record]} for record"
        elsif !attributes[:record]
          attributes[:record] = false
        end

        if attributes[:recordFileFormat] && !VALID_RECORD_FILE_FORMAT_VALUES.include?(attributes[:recordFileFormat])
          raise PlivoXMLError, "invalid attribute value #{attributes[:recordFileFormat]} for recordFileFormat"
        elsif !attributes[:recordFileFormat]
          attributes[:recordFileFormat] = 'mp3'
        end

        if attributes[:recordingCallbackMethod] && !VALID_RECORDING_CALLBACK_METHOD_VALUES.include?(attributes[:recordingCallbackMethod])
          raise PlivoXMLError, "invalid attribute value #{attributes[:recordingCallbackMethod]} for recordingCallbackMethod"
        elsif !attributes[:recordingCallbackMethod]
          attributes[:recordingCallbackMethod] = 'mp3'
        end

        if !attributes[:statusCallbackEvents]
          attributes[:statusCallbackEvents] = 'mpc-state-changes,participant-state-changes'
        end

        if attributes[:statusCallbackMethod] && !VALID_STATUS_CALLBACK_METHOD_VALUES.include?(attributes[:statusCallbackMethod])
          raise PlivoXMLError, "invalid attribute value #{attributes[:statusCallbackMethod]} for statusCallbackMethod"
        elsif !attributes[:statusCallbackMethod]
          attributes[:statusCallbackMethod] = 'POST'
        end

        if attributes[:stayAlone] && !VALID_STAY_ALONE_VALUES.include?(attributes[:stayAlone])
          raise PlivoXMLError, "invalid attribute value #{attributes[:stayAlone]} for statusCallbackMethod"
        elsif !attributes[:stayAlone]
          attributes[:stayAlone] = false
        end

        if attributes[:coachMode] && !VALID_COACH_MODE_VALUES.include?(attributes[:coachMode])
          raise PlivoXMLError, "invalid attribute value #{attributes[:coachMode]} for coachMode"
        elsif !attributes[:coachMode]
          attributes[:coachMode] = true
        end

        if attributes[:mute] && !VALID_MUTE_VALUES.include?(attributes[:mute])
          raise PlivoXMLError, "invalid attribute value #{attributes[:mute]} for mute"
        elsif !attributes[:mute]
          attributes[:mute] = false
        end

        if attributes[:hold] && !VALID_HOLD_VALUES.include?(attributes[:hold])
          raise PlivoXMLError, "invalid attribute value #{attributes[:hold]} for hold"
        elsif !attributes[:hold]
          attributes[:hold] = false
        end

        if attributes[:startMpcOnEnter] && !VALID_START_MPC_ON_ENTER_VALUES.include?(attributes[:startMpcOnEnter])
          raise PlivoXMLError, "invalid attribute value #{attributes[:startMpcOnEnter]} for startMpcOnEnter"
        elsif !attributes[:startMpcOnEnter]
          attributes[:startMpcOnEnter] = true
        end

        if attributes[:endMpcOnExit] && !VALID_END_MPC_ON_EXIT_VALUES.include?(attributes[:endMpcOnExit])
          raise PlivoXMLError, "invalid attribute value #{attributes[:endMpcOnExit]} for endMpcOnExit"
        elsif !attributes[:endMpcOnExit]
          attributes[:endMpcOnExit] = false
        end

        if !attributes[:enterSound]
          attributes[:enterSound] = 'beep:1'
        end

        if attributes[:enterSoundMethod] && !VALID_ENTER_SOUND_METHOD_VALUES.include?(attributes[:enterSoundMethod])
          raise PlivoXMLError, "invalid attribute value #{attributes[:enterSoundMethod]} for enterSoundMethod"
        elsif !attributes[:enterSoundMethod]
          attributes[:enterSoundMethod] = 'GET'
        end

        if !attributes[:exitSound]
          attributes[:exitSound] = 'beep:2'
        end

        if attributes[:exitSoundMethod] && !VALID_EXIT_SOUND_METHOD_VALUES.include?(attributes[:exitSoundMethod])
          raise PlivoXMLError, "invalid attribute value #{attributes[:exitSoundMethod]} for exitSoundMethod"
        elsif !attributes[:exitSoundMethod]
          attributes[:exitSoundMethod] = 'GET'
        end

        if attributes[:onExitActionMethod] && !VALID_ON_EXIT_ACTION_METHOD_VALUES.include?(attributes[:onExitActionMethod])
          raise PlivoXMLError, "invalid attribute value #{attributes[:onExitActionMethod]} for onExitActionMethod"
        elsif !attributes[:onExitActionMethod]
          attributes[:onExitActionMethod] = 'POST'
        end

        if attributes[:relayDTMFInputs] && !VALID_RELAY_DTMF_INPUTS_VALUES.include?(attributes[:relayDTMFInputs])
          raise PlivoXMLError, "invalid attribute value #{attributes[:relayDTMFInputs]} for relayDTMFInputs"
        elsif !attributes[:relayDTMFInputs]
          attributes[:relayDTMFInputs] = false
        end

        raise PlivoXMLError, 'No MPC name set for the MPC' unless body
        super(body, attributes)
      end

    end
  end
end
