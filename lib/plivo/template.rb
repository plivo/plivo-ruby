require_relative "resources"
require_relative "base_client"
require_relative "base"
require_relative "location"
module Plivo
    class Template
      attr_accessor :name, :language, :components
  
      def initialize(name: nil, language: nil, components: nil)
        @name = name
        @language = language
        @components = components
      end
  
      def to_hash
        {
          name: @name,
          language: @language,
          components: @components&.map(&:to_hash)&.reject { |h| h.values.all?(&:nil?) }
        }.reject { |_, v| v.nil? }
      end
    end
  
    class Component
      attr_accessor :type, :sub_type, :index, :parameters
  
      def initialize(type: nil, sub_type: nil, index: nil, parameters: nil)
        @type = type
        @sub_type = sub_type
        @index = index
        @parameters = parameters
      end
  
      def to_hash
        {
          type: @type,
          sub_type: @sub_type,
          index: @index,
          parameters: @parameters&.map(&:to_hash)&.reject { |h| h.values.all?(&:nil?) }
        }.reject { |_, v| v.nil? }
      end
    end
  
    class Parameter
      attr_accessor :type, :text, :media, :payload, :currency, :date_time, :location, :parameter_name
  
      def initialize(type: nil, text: nil, media: nil, payload: nil, currency: nil, date_time: nil, location: nil, parameter_name: nil)
        @type = type
        @text = text
        @media = media
        @payload = payload
        @currency = currency
        @date_time = date_time
        @location = location
        @parameter_name = parameter_name
      end
  
      def to_hash
        {
          type: @type,
          text: @text,
          media: @media,
          payload: @payload,
          currency: @currency&.to_hash,
          date_time: @date_time&.to_hash,
          location: @location&.to_hash,
          parameter_name: @parameter_name
        }.reject { |_, v| v.nil? }
      end
    end
  
    class Currency
      attr_accessor :fallback_value, :currency_code, :amount_1000
  
      def initialize(fallback_value: nil, currency_code: nil, amount_1000: nil)
        @fallback_value = fallback_value
        @currency_code = currency_code
        @amount_1000 = amount_1000
      end
  
      def to_hash
        {
          fallback_value: @fallback_value,
          currency_code: @currency_code,
          amount_1000: @amount_1000
        }.reject { |_, v| v.nil? }
      end
    end
  
    class DateTime
      attr_accessor :fallback_value
  
      def initialize(fallback_value: nil)
        @fallback_value = fallback_value
      end
  
      def to_hash
        {
          fallback_value: @fallback_value
        }.reject { |_, v| v.nil? }
      end
    end
  end
  