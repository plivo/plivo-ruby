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
      VALID_METHOD_VALUES = %w[GET POST]
      VALID_BOOL_VALUES = [true, false]
      VALID_RECORD_FILE_FORMAT_VALUES = %w[mp3 wav]

      def initialize(body, attributes = {})
        if attributes[:role] && !VALID_ROLE_VALUES.include?(attributes[:role].downcase)
          raise PlivoXMLError, "invalid attribute value #{attributes[:role]} for maxDuration"
        elsif !attributes[:role]
          raise PlivoXMLError, "role not mentioned : possible values - Agent / Supervisor / Customer"
        end

        if attributes[:maxDuration] && attributes[:maxDuration]<300 && attributes[:maxDuration]>28800
          raise PlivoXMLError, "invalid attribute value #{attributes[:maxDuration]} for maxDuration"
        elsif !attributes[:maxDuration]
          attributes[:maxDuration] = 14400
        end

        if attributes[:maxParticipants] && attributes[:maxParticipants]<2 && attributes[:maxParticipants]>10
          raise PlivoXMLError, "invalid attribute value #{attributes[:maxParticipants]} for maxParticipants"
        elsif !attributes[:maxParticipants]
          attributes[:maxParticipants] = 10
        end

        if attributes[:waitMusicMethod] && !VALID_METHOD_VALUES.include?(attributes[:waitMusicMethod].uppercase)
          raise PlivoXMLError, "invalid attribute value #{attributes[:waitMusicMethod]} for waitMusicMethod"
        elsif !attributes[:waitMusicMethod]
          attributes[:waitMusicMethod] = 'GET'
        end

        if attributes[:agentHoldMusicMethod] && !VALID_METHOD_VALUES.include?(attributes[:agentHoldMusicMethod].uppercase)
          raise PlivoXMLError, "invalid attribute value #{attributes[:agentHoldMusicMethod]} for agentHoldMusicMethod"
        elsif !attributes[:agentHoldMusicMethod]
          attributes[:agentHoldMusicMethod] = 'GET'
        end

        if attributes[:customerHoldMusicMethod] && !VALID_METHOD_VALUES.include?(attributes[:customerHoldMusicMethod].uppercase)
          raise PlivoXMLError, "invalid attribute value #{attributes[:customerHoldMusicMethod]} for customerHoldMusicMethod"
        elsif !attributes[:customerHoldMusicMethod]
          attributes[:customerHoldMusicMethod] = 'GET'
        end

        if attributes[:record] && !VALID_BOOL_VALUES.include?(attributes[:record])
          raise PlivoXMLError, "invalid attribute value #{attributes[:record]} for record"
        elsif !attributes[:record]
          attributes[:record] = false
        end

        if attributes[:recordFileFormat] && !VALID_RECORD_FILE_FORMAT_VALUES.include?(attributes[:recordFileFormat])
          raise PlivoXMLError, "invalid attribute value #{attributes[:recordFileFormat]} for recordFileFormat"
        elsif !attributes[:recordFileFormat]
          attributes[:recordFileFormat] = 'mp3'
        end

        if attributes[:recordingCallbackMethod] && !VALID_METHOD_VALUES.include?(attributes[:recordingCallbackMethod].uppercase)
          raise PlivoXMLError, "invalid attribute value #{attributes[:recordingCallbackMethod]} for recordingCallbackMethod"
        elsif !attributes[:recordingCallbackMethod]
          attributes[:recordingCallbackMethod] = 'mp3'
        end

        if attributes[:statusCallbackEvents] && multi_valid_param?(:statusCallbackEvents, attributes[:statusCallbackEvents], String, false, %w[mpc-state-changes participant-state-changes participant-speak-events participant-digit-input-events add-participant-api-events], true, ',') == true
          raise PlivoXMLError, "invalid attribute value #{attributes[:statusCallbackEvents]} for statusCallbackEvents"
        elsif !attributes[:statusCallbackEvents]
          attributes[:statusCallbackEvents] = 'mpc-state-changes,participant-state-changes'
        end

        if attributes[:statusCallbackMethod] && !VALID_METHOD_VALUES.include?(attributes[:statusCallbackMethod].uppercase)
          raise PlivoXMLError, "invalid attribute value #{attributes[:statusCallbackMethod]} for statusCallbackMethod"
        elsif !attributes[:statusCallbackMethod]
          attributes[:statusCallbackMethod] = 'POST'
        end

        if attributes[:stayAlone] && !VALID_BOOL_VALUES.include?(attributes[:stayAlone])
          raise PlivoXMLError, "invalid attribute value #{attributes[:stayAlone]} for stayAlone"
        elsif !attributes[:stayAlone]
          attributes[:stayAlone] = false
        end

        if attributes[:coachMode] && !VALID_BOOL_VALUES.include?(attributes[:coachMode])
          raise PlivoXMLError, "invalid attribute value #{attributes[:coachMode]} for coachMode"
        elsif !attributes[:coachMode]
          attributes[:coachMode] = true
        end

        if attributes[:mute] && !VALID_BOOL_VALUES.include?(attributes[:mute])
          raise PlivoXMLError, "invalid attribute value #{attributes[:mute]} for mute"
        elsif !attributes[:mute]
          attributes[:mute] = false
        end

        if attributes[:hold] && !VALID_BOOL_VALUES.include?(attributes[:hold])
          raise PlivoXMLError, "invalid attribute value #{attributes[:hold]} for hold"
        elsif !attributes[:hold]
          attributes[:hold] = false
        end

        if attributes[:startMpcOnEnter] && !VALID_BOOL_VALUES.include?(attributes[:startMpcOnEnter])
          raise PlivoXMLError, "invalid attribute value #{attributes[:startMpcOnEnter]} for startMpcOnEnter"
        elsif !attributes[:startMpcOnEnter]
          attributes[:startMpcOnEnter] = true
        end

        if attributes[:endMpcOnExit] && !VALID_BOOL_VALUES.include?(attributes[:endMpcOnExit])
          raise PlivoXMLError, "invalid attribute value #{attributes[:endMpcOnExit]} for endMpcOnExit"
        elsif !attributes[:endMpcOnExit]
          attributes[:endMpcOnExit] = false
        end

        if !attributes[:enterSound]
          attributes[:enterSound] = 'beep:1'
        end

        if attributes[:enterSoundMethod] && !VALID_METHOD_VALUES.include?(attributes[:enterSoundMethod].uppercase)
          raise PlivoXMLError, "invalid attribute value #{attributes[:enterSoundMethod]} for enterSoundMethod"
        elsif !attributes[:enterSoundMethod]
          attributes[:enterSoundMethod] = 'GET'
        end

        if !attributes[:exitSound]
          attributes[:exitSound] = 'beep:2'
        end

        if attributes[:exitSoundMethod] && !VALID_METHOD_VALUES.include?(attributes[:exitSoundMethod].uppercase)
          raise PlivoXMLError, "invalid attribute value #{attributes[:exitSoundMethod]} for exitSoundMethod"
        elsif !attributes[:exitSoundMethod]
          attributes[:exitSoundMethod] = 'GET'
        end

        if attributes[:onExitActionMethod] && !VALID_METHOD_VALUES.include?(attributes[:onExitActionMethod].uppercase)
          raise PlivoXMLError, "invalid attribute value #{attributes[:onExitActionMethod]} for onExitActionMethod"
        elsif !attributes[:onExitActionMethod]
          attributes[:onExitActionMethod] = 'POST'
        end

        if attributes[:relayDTMFInputs] && !VALID_BOOL_VALUES.include?(attributes[:relayDTMFInputs])
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
