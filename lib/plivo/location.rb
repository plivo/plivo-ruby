module Plivo
    class Location
      attr_accessor :latitude, :longitude, :name, :address

      def initialize(latitude: nil, longitude: nil, name: nil, address: nil)
        @latitude = latitude
        @longitude = longitude
        @name = name
        @address = address
      end
  
      def to_hash
        {
          latitude: @latitude,
          longitude: @longitude,
          name: @name,
          address: @address
        }.reject { |_, v| v.nil? }
      end
    end
  end
  