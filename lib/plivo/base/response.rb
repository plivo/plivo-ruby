module Plivo
  module Base
    ##
    # A class to provide a blanket response based on what is
    # being received from Plivo servers.
    #
    # This will be used only during POST and DELETE requests.
    class Response
      ##
      # Instantiating a new instance requires a response_hash
      # The id_symbol should contain a Symbol that represents
      # the identifier of the resource for which this response
      # is being generated for.

      def initialize(response_hash, id_symbol = nil)
        return unless response_hash

        response_hash.each do |k, v|
          instance_variable_set("@#{k}", v)
          self.class.send(:attr_reader, k)
        end
        return unless id_symbol && response_hash.key?(id_symbol)

        self.class.send(:attr_reader, :id)
        @id = response_hash[id_symbol]
      end

      def to_s
        h = self.instance_variables.map do |attribute|
          key = attribute.to_s.gsub('@','')
          [key, self.instance_variable_get(attribute)]
        end.to_h
        h.to_s
      end

    end
  end
end
