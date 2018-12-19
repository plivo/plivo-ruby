module Plivo
  module Resources
    class NodeInterface < Base::ResourceInterface
      def initialize(client, resource_list_json=nil)
        super
      end

      def getNode(node_id, node_type)
        @_resource_uri = ['', 'v1', 'phlo', @_phlo_id, node_type, ''].join('/')
        @_resource_type = configure_node_type(node_type)
        perform_get(node_id)
      end

      private
      def configure_node_type(node_type)
        case node_type
        when 'multi_party_call'
          MultiPartyCall
        # when 'conference_bridge'
        #   ConferenceBridge
        end
      end
    end

    class Node < Base::Resource
      def initialize(client,options=nil)
        @_identifier_string = 'node_id'
        super
        configure_resource_uri
      end

      def to_s
        {
            api_id: @api_id,
            node_id: @node_id,
            phlo_id: @phlo_id,
            name: @name,
            node_type: @node_type,
            created_on: @created_on
        }.to_s
      end

      def member(member_address)
        options = {'member_address' => member_address, 'node_id' => @id, 'phlo_id' => @phlo_id, 'node_type' => @node_type}
        Member.new(@_client, {resource_json: options})
      end

      private
      def configure_resource_uri
        @_resource_uri = ['', 'v1', 'phlo', @phlo_id, @node_type, @id, ''].join('/')
      end
    end

    class MultiPartyCall < Node
      def initialize(client,options=nil)
        @_name = 'multi_party_call'
        super
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
    end

    # class ConferenceBridge < Node
    #   def initialize(client,options=nil)
    #     @_name = 'conference_bridge'
    #     super
    #   end
    # end
  end
end
