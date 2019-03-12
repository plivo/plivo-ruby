module Plivo
  module Resources
    include Plivo::Utils

    class Phlo < Base::Resource

      def initialize(client, options = nil)
        @_name = 'phlo'
        @_identifier_string = 'phlo_id'
        super
      end

      def to_s
        {
            api_id: @api_id,
            phlo_id: @phlo_id,
            name: @name,
            created_on: @created_on,
            phlo_run_id: @phlo_run_id
        }.to_s
      end

      def multi_party_call(node_id)
        nodeInterface = NodeInterface.new(@_client, {_phlo_id: @id})
        nodeInterface.getNode(node_id, 'multi_party_call')
      end

      # def conference_bridge(node_id)
      #   nodeInterface = NodeInterface.new(@_client, {_phlo_id: @id})
      #   nodeInterface.getNode(node_id, 'conference_bridge')
      # end

      def run(params=nil)
        @_resource_uri = ['', 'v1', 'account', @_client.auth_id, @_name, @id, ''].join('/')
        perform_run(params)
      end
    end


    class PhloInterface < Base::ResourceInterface

      def initialize(client, resource_list_json = nil)
        @_name = 'phlo'
        @_resource_type = Phlo
        super
      end

      def get(phlo_id)
        perform_get(phlo_id)
      end

    end

  end
end
