module Plivo
  module Resources

    class NodeInterface < Base::ResourceInterface

      def initialize(client, resource_list_json=nil)
        super
      end

      def getNode(node_id, node_type)
        @_resource_uri = ['', 'phlo', @_phlo_id, node_type, ''].join('/')
        @_resource_type = configure_node_type(node_type)
        perform_get(node_id)
      end

      private

      def configure_node_type(node_type)
        case node_type
        when 'multi_party_call'
          MultiPartyCall
        when 'conference_bridge'
          ConferenceBridge
        end
      end
    end

    # Nodes

    class MultiPartyCall < Base::Resource

      def initialize(client,options=nil)
        @_name = 'multi_party_call'
        @_identifier_string = 'node_id'
        super
        configure_resource_uri
      end

      def call(trigger_source, to, role)
        payload = {action: 'call', trigger_source: trigger_source, to: to, role: role}
        perform_update(payload)
      end

      def warm_transfer(trigger_source, to, role='agent')
        payload = {action: 'warm_transfer', trigger_source: trigger_source, to: to, role: role}
        perform_update(payload)
      end

      def cold_transfer(trigger_source, to, role='agent')
        payload = {action: 'cold_transfer', trigger_source: trigger_source, to: to, role: role}
        perform_update(payload)
      end

      def abort_transfer(trigger_source, to, role='agent')
        payload = {action: 'abort_transfer', trigger_source: trigger_source, to: to, role: role}
        perform_update(payload)
      end

      def member(member_address)
        options = {'member_address' => member_address, 'node_id' => @id, 'phlo_id' => @phlo_id, 'node_type' => @node_type}
        Member.new(@_client, {resource_json: options})
      end

      private

      def configure_resource_uri
        @_resource_uri = ['', 'phlo', @phlo_id, @node_type, @id, ''].join('/')
      end
    end

    class Member < Base::Resource
      def initialize(client, options)
        @_name = 'member'
        @_identifier_string = 'member_address'
        super
        configure_resource_uri
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

      def remove
        perform_delete
      end

      def mute
        perform_update({action: 'mute'})
      end

      def unmute
        perform_update({action: 'unmute'})
      end

      private

      def configure_resource_uri
        @_resource_uri = ['', 'phlo', @phlo_id, @node_type, @node_id, 'members', @id, ''].join('/')
      end
    end

    class ConferenceBridge < Base::Resource
      def initialize(client,options=nil)
        @_name = 'conference_bridge'
        @_identifier_string = 'node_id'
        super
      end

      def member(member_address)
        options = {'member_address' => member_address, 'node_id' => @id, 'phlo_id' => @phlo_id, 'node_type' => @node_type}
        Member.new(@_client, {resource_json: options})
      end
    end
  end
end