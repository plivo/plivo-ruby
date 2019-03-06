module Plivo
  module Resources
    class Member < Base::Resource
      def initialize(client, options)
        @_name = 'member'
        @_identifier_string = 'member_address'
        super
        configure_resource_uri
      end

      def to_s
        {
            api_id: @api_id,
            node_id: @node_id,
            phlo_id: @phlo_id,
            node_type: @node_type,
            member_address: @member_address,
            created_on: @created_on
        }.to_s
      end

      def hold
        perform_update({action: 'hold'})
      end

      def unhold
        perform_update({action: 'unhold'})
      end

      def voicemail_drop
        perform_update({action: 'voicemail_drop'})
      end

      def resume_call
        perform_update({action: 'resume_call'})
      end

      def hangup
        perform_update({action: 'hangup'})
      end

      # def remove
      #   perform_delete
      # end

      def mute
        perform_update({action: 'mute'})
      end

      def unmute
        perform_update({action: 'unmute'})
      end

      def abort_transfer
        perform_update({action: 'abort_transfer'})
      end

      private
      def configure_resource_uri
        @_resource_uri = ['', 'v1', 'phlo', @phlo_id, @node_type, @node_id, 'members', @id, ''].join('/')
      end
    end
  end
end
