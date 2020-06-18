module Plivo
  module XML
    class MultiPartyCall < Element
      @nestables = []
      @valid_attributes = %w[max_duration max_participants wait_music_url
                             wait_music_method agent_hold_music_url agent_hold_music_method
                             customer_hold_music_url customer_hold_music_method record
                             record_file_format recording_callback_url recording_callback_method
                             status_callback_events status_callback_url status_callback_method
                             stay_alone role coach_mode mute hold start_mpc_on_enter end_mpc_on_exit
                             enter_sound enter_sound_method exit_sound exit_sound_method
                             on_exit_action_url on_exit_action_method relay_dtmf_inputs]

      def initialize(body, attributes = {})
        raise PlivoXMLError, 'No MPC name set for the MPC' unless body
        super(body, attributes)
      end

    end
  end
end
