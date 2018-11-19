module Plivo
  module Resources
    include Plivo::Utils

    class Phlo < Base::Resource

      def initialize(client, options = nil)
        @_name = 'Phlo'
        @_identifier_string = 'phlo_id'
        super
      end


      def multi_party_call(node_id)
        nodeInterface = NodeInterface.new(@_client, {_phlo_id: @id})
        nodeInterface.getNode(node_id, 'multi_party_call')
      end

      def conference_bridge(node_id)
        nodeInterface = NodeInterface.new(@_client, {_phlo_id: @id})
        nodeInterface.getNode(node_id, 'conference_bridge')
      end

      def run(params=nil)
        @_resource_uri = ['', 'Account', @_client.auth_id, @_name, @id, ''].join('/')
        perform_update(params)
      end
    end


    class PhloInterface < Base::ResourceInterface

      def initialize(client, resource_list_json = nil)
        @_name = 'Phlo'
        @_resource_type = Phlo
        super
      end

      def get(phlo_id)
        perform_get(phlo_id)
      end

    end

  end
end

