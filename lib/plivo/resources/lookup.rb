module Plivo
  module Resources
    include Plivo::Utils

    class LookupBaseResource
      def initialize(fields = nil)
        valid_param?(:fields, fields, Hash, false)
        fields.each do |k, v|
          instance_variable_set("@#{k}", v)
          self.class.send(:attr_reader, k)
        end
      end

      def to_s
        hash = {}
        instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
        hash.to_s
      end
    end

    class Country < LookupBaseResource
    end

    class NumberFormat < LookupBaseResource
    end

    class Carrier < LookupBaseResource
    end

    # Not subclassing from Base::Resource because it cannot set nested
    # attributes. Named the class 'LookupResponse' because the name
    # 'Number' is already taken.
    class LookupResponse < LookupBaseResource
      def initialize(client, options = nil)
        # there is no use for client here
        valid_param?(:options, options, Hash, false)
        parse_and_set(options[:resource_json]) if options.key?(:resource_json)
      end

      def parse_and_set(resp)
        return unless resp
        valid_param?(:resp, resp, Hash, true)

        resp.each do |k, v|
          case k
          when "country"
            instance_variable_set("@#{k}", Country.new(v))
          when "format"
            instance_variable_set("@#{k}", NumberFormat.new(v))
          when "carrier"
            instance_variable_set("@#{k}", Carrier.new(v))
          else
            instance_variable_set("@#{k}", v)
          end
          self.class.send(:attr_reader, k)
        end
      end
    end

    class LookupInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_resource_type = LookupResponse
        @_identifier_string = "phone_number"
        super
        # Override _resource_uri only after calling super
        @_resource_uri = "/v1/Number/"
      end

      ##
      # Lookup a number
      # @param [String] number
      # @return [LookupResponse] LookupResponse
      def get(number, type = "carrier")
        valid_param?(:number, number, [String, Symbol], true)
        perform_get(number, { "type" => type })
      end

      private

      # overridden to ensure 'Account' and extra shash isn't added to URL path
      def perform_get(identifier, params = nil)
        valid_param?(:identifier, identifier, [String, Symbol], true)
        response_json = @_client.send_request(@_resource_uri + identifier.to_s, "GET", params, nil, false, is_voice_request: @_is_voice_request, is_lookup_request: true)
        @_resource_type.new(@_client, resource_json: response_json)
      end
    end
  end
end
