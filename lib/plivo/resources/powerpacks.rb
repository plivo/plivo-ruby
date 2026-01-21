module Plivo
  module Resources
      include Plivo::Utils
  
      class Powerpack < Base::Resource
        def initialize(client, options = nil)
          @_name = 'Powerpack'
          @_identifier_string = 'uuid'
          super
        end

        def numberpool
          number_pool_uuid = getnumberpool_uuid(uuid)
          options = {'number_pool_id' => number_pool_uuid}
          NumberPool.new(@_client, {resource_json: options})
        end

        def delete(unrent_numbers = false)
            valid_param?(:unrent_numbers, unrent_numbers, [TrueClass, FalseClass],
              false, [true, false])
            
            params = {
              :unrent_numbers => unrent_numbers
            }
            perform_action_apiresponse('', 'DELETE', params)
            # perform_delete(params)
        end
        
        def update(options = nil)
          valid_param?(:options, options, Hash, true)
          params = {}
          if options.key?(:application_type) 
            params[:application_type] = options[:application_type]
          end
 
          if options.key?(:application_id) 
            params[:application_id] = options[:application_id]
          end
 
          if options.key?(:sticky_sender) 
            params[:sticky_sender] = options[:sticky_sender]
          end

          if options.key?(:local_connect) 
            params[:local_connect] = options[:local_connect]
          end
          if options.key?(:name) 
            params[:name] = options[:name]
          end
          if options.key?(:number_priority) 
            params[:number_priority] = options[:number_priority]
          end
          perform_action_apiresponse('', 'POST', params)
        end

        def list_numbers(options = nil)
          number_pool_uuid = getnumberpool_uuid(uuid)
          return perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Number',
          'GET') if options.nil?

          params = {}
  
          %i[offset limit].each do |param|
            if options.key?(param) && valid_param?(param, options[param],
                                                   [Integer, Integer], true)
              params[param] = options[param]
            end
          end
  
          if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
            raise_invalid_request('The maximum number of results that can be '\
            "fetched is 20. limit can't be more than 20 or less than 1")
          end
  
          if options.key?(:offset) && options[:offset] < 0
            raise_invalid_request("Offset can't be negative")
          end

          if options.key?(:starts_with) &&
            valid_param?(:starts_with, options[:starts_with], String, true)
           params[:starts_with] = options[:starts_with]
          end
          if options.key?(:country_iso2) &&
            valid_param?(:country_iso2, options[:country_iso2], String, true)
           params[:country_iso2] = options[:country_iso2]
          end
          if options.key?(:type) &&
            valid_param?(:type, options[:type], String, true)
           params[:type] = options[:type]
          end
          if options.key?(:service) &&
            valid_param?(:service, options[:service], String, true)
           params[:service] = options[:service]
          end
          perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Number',
          'GET', params, true)
        end

        def getnumberpool_uuid(uuid)
          valid_param?(:uuid, uuid, [String, Symbol], true)
          response = perform_action()
          numberpool_path = response.number_pool
          numberpool_array = numberpool_path.split("/")
          numberpool_array[5]
        end

        def count_numbers(options = nil)
          number_pool_uuid = getnumberpool_uuid(uuid)
          if options.nil?
           response = perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Number',
           'GET')
           meta = response['meta']
           return meta['total_count']
          end
         
          params = {}
  
          %i[offset limit].each do |param|
            if options.key?(param) && valid_param?(param, options[param],
                                                   [Integer, Integer], true)
              params[param] = options[param]
            end
          end
  
          if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
            raise_invalid_request('The maximum number of results that can be '\
            "fetched is 20. limit can't be more than 20 or less than 1")
          end
  
          if options.key?(:offset) && options[:offset] < 0
            raise_invalid_request("Offset can't be negative")
          end

          if options.key?(:starts_with) &&
            valid_param?(:starts_with, options[:starts_with], String, true)
           params[:starts_with] = options[:starts_with]
          end
          if options.key?(:country_iso2) &&
            valid_param?(:country_iso2, options[:country_iso2], String, true)
           params[:country_iso2] = options[:country_iso2]
          end
          if options.key?(:type) &&
            valid_param?(:type, options[:type], String, true)
           params[:type] = options[:type]
          end
          if options.key?(:service) &&
            valid_param?(:service, options[:service], String, true)
           params[:service] = options[:service]
          end
          response = perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Number',
          'GET', param, true)
          meta = response['meta']
          return meta['total_count']
        end

        def find_number(number, options = nil)
          number_pool_uuid = getnumberpool_uuid(uuid)
          if options.nil?
            return perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Number/' + number.to_s ,
                       'GET')
          end
          params = {}
          if options.key?(:service) &&
            valid_param?(:service, options[:service], String, true)
           params[:service] = options[:service]
          end
          perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Number/' + number.to_s ,
                       'GET', params)
        end

        def add_number(number, options = nil)
          number_pool_uuid = getnumberpool_uuid(uuid)
          if options.nil?
            return perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Number/' + number.to_s ,
                       'POST')
            return
          end
          params = {}
          if options.key?(:service) &&
            valid_param?(:service, options[:service], String, true)
           params[:service] = options[:service]
          end
          perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Number/' + number.to_s ,
                       'POST', params)
        end

        def add_tollfree(tollfree)
          number_pool_uuid = getnumberpool_uuid(uuid)
          perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Tollfree/' + tollfree.to_s ,
                       'POST')
        end
  
        def remove_number(number, unrent= false)
          number_pool_uuid = getnumberpool_uuid(uuid)
          perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Number/' + number.to_s ,
                       'DELETE', { unrent: unrent }, false)
        end

        def remove_tollfree(number, unrent= false)
          number_pool_uuid = getnumberpool_uuid(uuid)
          perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Tollfree/' + number.to_s ,
                       'DELETE', { unrent: unrent }, false)
        end

        def remove_shortcode(number)
          number_pool_uuid = getnumberpool_uuid(uuid)
          perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Shortcode/' + number.to_s ,
                       'DELETE', { unrent: false }, false)
        end

        def list_shortcodes(options = nil)
          number_pool_uuid = getnumberpool_uuid(uuid)
          return perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Shortcode',
                       'GET') if options.nil?
          params = {}
          %i[offset limit].each do |param|
            if options.key?(param) && valid_param?(param, options[param],
                                                   [Integer, Integer], true)
              params[param] = options[param]
            end
          end
  
          if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
            raise_invalid_request('The maximum number of results that can be '\
            "fetched is 20. limit can't be more than 20 or less than 1")
          end
  
          if options.key?(:offset) && options[:offset] < 0
            raise_invalid_request("Offset can't be negative")
          end
          perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Shortcode',
                       'GET', params)
        end

        def list_tollfree(options = nil)
          number_pool_uuid = getnumberpool_uuid(uuid)
          return perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Tollfree',
                       'GET') if options.nil?
          params = {}
          %i[offset limit].each do |param|
            if options.key?(param) && valid_param?(param, options[param],
                                                   [Integer, Integer], true)
              params[param] = options[param]
            end
          end
  
          if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
            raise_invalid_request('The maximum number of results that can be '\
            "fetched is 20. limit can't be more than 20 or less than 1")
          end
  
          if options.key?(:offset) && options[:offset] < 0
            raise_invalid_request("Offset can't be negative")
          end
          perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Tollfree',
                       'GET', params)
        end
        
        def find_shortcode(shortcode)
          number_pool_uuid = getnumberpool_uuid(uuid)
          perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Shortcode/' + shortcode.to_s ,
                       'GET')
        end

        def find_tollfree(tollfree)
          number_pool_uuid = getnumberpool_uuid(uuid)
          perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Tollfree/' + tollfree.to_s ,
                       'GET')
        end

        def buy_add_number(options = nil)
          number_pool_uuid = getnumberpool_uuid(uuid)
          params = {}
          params[:rent] = true
          if options.key?(:service) &&
            valid_param?(:service, options[:service], String, true)
           params[:service] = options[:service]
          end
          if options.key?(:number)
            return perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Number/' + options[:number].to_s ,
                       'POST', params)
          end
          if options.key?(:country_iso2).nil?
            raise_invalid_request('country_iso is cannot be empty')
          end
      
          %i[offset limit].each do |param|
            if options.key?(param) && valid_param?(param, options[param],
                                                   [Integer, Integer], true)
              params[param] = options[param]
            end
          end
  
          if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
            raise_invalid_request('The maximum number of results that can be '\
            "fetched is 20. limit can't be more than 20 or less than 1")
          end
  
          if options.key?(:offset) && options[:offset] < 0
            raise_invalid_request("Offset can't be negative")
          end

          if options.key?(:pattern) &&
            valid_param?(:pattern, options[:pattern], String, true)
           params[:starts_with] = options[:pattern]
          end
          if options.key?(:country_iso2) &&
            valid_param?(:country_iso2, options[:country_iso2], String, true)
           params[:country_iso] = options[:country_iso2]
          end
          if options.key?(:type) &&
            valid_param?(:type, options[:type], String, true)
           params[:type] = options[:type]
          end

         response = perform_custom_action_apiresponse('PhoneNumber',
         'GET', params, true)
          numbers = response['objects'][0]['number']
          perform_custom_action_apiresponse('NumberPool/' + number_pool_uuid + '/Number/' + numbers.to_s,
                       'POST', params)
        end

        def to_s
          {
            name: @name,
            application_type: @application_type,
            application_id: @application_id,
            sticky_sender: @sticky_sender,
            local_connect: @local_connect,
            uuid: @uuid,
            number_pool:@number_pool,
            created_on:@created_on,
            number_priority:@number_priority
          }.to_s
        end
        def to_json
          {
            name: @name,
            application_type: @application_type,
            application_id: @application_id,
            sticky_sender: @sticky_sender,
            local_connect: @local_connect,
            uuid: @uuid,
            number_pool:@number_pool,
            created_on:@created_on,
            number_priority:@number_priority
          }.to_json
        end
      end
      class NumberPool< Base::Resource
        def initialize(client, options = nil)
          @_name = 'Numberpool'
          @_identifier_string = 'number_pool_id'
          super
        end

        def numbers
          options = {'number_pool_id' => @number_pool_id}
          Numbers.new(@_client, {resource_json:options })
        end
        def shortcodes
          options = {'number_pool_id' => @number_pool_id}
          Shortcode.new(@_client, {resource_json: options})
        end
        def tollfree
          options = {'number_pool_id' => @number_pool_id}
          Tollfree.new(@_client, {resource_json: options})
        end
      end

      class Numbers < Base::Resource
        def initialize(client, options = nil)
          @_name = 'Numbers'
          @_identifier_string = 'number_pool_id'
          super
        end

        def list(options = nil)
          return perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Number',
          'GET') if options.nil?

          params = {}
          %i[offset limit].each do |param|
            if options.key?(param) && valid_param?(param, options[param],
                                                   [Integer, Integer], true)
              params[param] = options[param]
            end
          end
  
          if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
            raise_invalid_request('The maximum number of results that can be '\
            "fetched is 20. limit can't be more than 20 or less than 1")
          end
  
          if options.key?(:offset) && options[:offset] < 0
            raise_invalid_request("Offset can't be negative")
          end

          if options.key?(:pattern) &&
            valid_param?(:pattern, options[:pattern], String, true)
           params[:starts_with] = options[:pattern]
          end
          if options.key?(:country_iso2) &&
            valid_param?(:country_iso2, options[:country_iso2], String, true)
           params[:country_iso2] = options[:country_iso2]
          end
          if options.key?(:type) &&
            valid_param?(:type, options[:type], String, true)
           params[:type] = options[:type]
          end
          if options.key?(:service) &&
            valid_param?(:service, options[:service], String, true)
           params[:service] = options[:service]
          end
          perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Number',
          'GET', params, true)
        end
        def count(options = nil)
          if options.nil?
           response = perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Number',
           'GET')
           meta = response['meta']
           return meta['total_count']
          end
         
          params = {}
  
          %i[offset limit].each do |param|
            if options.key?(param) && valid_param?(param, options[param],
                                                   [Integer, Integer], true)
              params[param] = options[param]
            end
          end
  
          if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
            raise_invalid_request('The maximum number of results that can be '\
            "fetched is 20. limit can't be more than 20 or less than 1")
          end
  
          if options.key?(:offset) && options[:offset] < 0
            raise_invalid_request("Offset can't be negative")
          end

          if options.key?(:pattern) &&
            valid_param?(:pattern, options[:pattern], String, true)
           params[:starts_with] = options[:pattern]
          end
          if options.key?(:country_iso2) &&
            valid_param?(:country_iso2, options[:country_iso2], String, true)
           params[:country_iso2] = options[:country_iso2]
          end
          if options.key?(:type) &&
            valid_param?(:type, options[:type], String, true)
           params[:type] = options[:type]
          end
          if options.key?(:service) &&
            valid_param?(:service, options[:service], String, true)
           params[:service] = options[:service]
          end
          response = perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Number',
          'GET', params, true)
          meta = response['meta']
          return meta['total_count']
        end

        def find(number, options = nil)
          if options.nil?
            return perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Number/' + number.to_s ,
                       'GET')
          end
          params = {}
          if options.key?(:service) &&
            valid_param?(:service, options[:service], String, true)
           params[:service] = options[:service]
          end
          perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Number/' + number.to_s ,
                       'GET', params)
        end

        def add(number, options = nil)
          if options.nil?
            return perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Number/' + number.to_s ,
                       'POST')
          end
          params = {}
          if options.key?(:service) &&
            valid_param?(:service, options[:service], String, true)
           params[:service] = options[:service]
          end
          perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Number/' + number.to_s ,
                       'POST', params)
        end
  
        def remove(number, unrent= false)
          perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Number/' + number.to_s ,
                       'DELETE', { unrent: unrent }, false)
        end

        def buy_add_number(options = nil)
          params = {}
          params[:rent] = true
          if options.key?(:service) &&
            valid_param?(:service, options[:service], String, true)
           params[:service] = options[:service]
          end
          if options.key?(:number)
            return perform_custom_action_apiresponse('NumberPool/' + number_pool_id + '/Number/' + options[:number].to_s ,
                       'POST', params)
          end
          if options.key?(:country_iso2).nil?
            raise_invalid_request('country_iso is cannot be empty')
          end
          params = {}
  
          %i[offset limit].each do |param|
            if options.key?(param) && valid_param?(param, options[param],
                                                   [Integer, Integer], true)
              params[param] = options[param]
            end
          end
  
          if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
            raise_invalid_request('The maximum number of results that can be '\
            "fetched is 20. limit can't be more than 20 or less than 1")
          end
  
          if options.key?(:offset) && options[:offset] < 0
            raise_invalid_request("Offset can't be negative")
          end

          if options.key?(:pattern) &&
            valid_param?(:pattern, options[:pattern], String, true)
           params[:starts_with] = options[:pattern]
          end
          if options.key?(:country_iso2) &&
            valid_param?(:country_iso2, options[:country_iso2], String, true)
           params[:country_iso] = options[:country_iso2]
          end
          if options.key?(:type) &&
            valid_param?(:type, options[:type], String, true)
           params[:type] = options[:type]
          end

         response = perform_custom_action_apiresponse('PhoneNumber',
         'GET', params, true)
          numbers = response['objects'][0]['number']
          params[:rent] = true
          perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Number/' + numbers.to_s,
                       'POST', params)
        end

      end

      class Shortcode < Base::Resource
        def initialize(client, options = nil)
          @_name = 'Shortcode'
          @_identifier_string = 'number_pool_id'
          super
        end
        def list(options = nil)
          return perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Shortcode',
                       'GET') if options.nil?
          params = {}
          %i[offset limit].each do |param|
            if options.key?(param) && valid_param?(param, options[param],
                                                   [Integer, Integer], true)
              params[param] = options[param]
            end
          end
  
          if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
            raise_invalid_request('The maximum number of results that can be '\
            "fetched is 20. limit can't be more than 20 or less than 1")
          end
  
          if options.key?(:offset) && options[:offset] < 0
            raise_invalid_request("Offset can't be negative")
          end
          perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Shortcode',
                       'GET')
        end
        
        def find(shortcode)
          perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Shortcode/' + shortcode.to_s ,
                       'GET')
        end

        def remove(shortcode)
          perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Shortcode/' + shortcode.to_s ,
                       'DELETE', { unrent: false }, false)
        end
      end

      class Tollfree < Base::Resource
        def initialize(client, options = nil)
          @_name = 'Tollfree'
          @_identifier_string = 'number_pool_id'
          super
        end

        def add(tollfree)
          perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Tollfree/' + tollfree.to_s ,
                       'POST')
        end

        def list(options = nil)
          return perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Tollfree',
                       'GET') if options.nil?
          params = {}
          %i[offset limit].each do |param|
            if options.key?(param) && valid_param?(param, options[param],
                                                   [Integer, Integer], true)
              params[param] = options[param]
            end
          end
  
          if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
            raise_invalid_request('The maximum number of results that can be '\
            "fetched is 20. limit can't be more than 20 or less than 1")
          end
  
          if options.key?(:offset) && options[:offset] < 0
            raise_invalid_request("Offset can't be negative")
          end
          perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Tollfree',
                       'GET')
        end
        
        def find(tollfree)
          perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Tollfree/' + tollfree.to_s ,
                       'GET')
        end

        def remove(tollfree, unrent= false)
          perform_custom_action_apiresponse('NumberPool/' + @number_pool_id + '/Tollfree/' + tollfree.to_s ,
                       'DELETE', { unrent: unrent }, false)
        end
      end
  
      class PowerpackInterface < Base::ResourceInterface
        def initialize(client, resource_list_json = nil)
          @_name = 'Powerpack'
          @_resource_type = Powerpack
          @_identifier_string = 'powerpack'
          super
        end
       
        def create(name, options = nil)
          valid_param?(:name, name, [String, Symbol], true)
  
          if name.nil? 
            raise InvalidRequestError, 'powerpack name cannot be empty'
          end
  
  
          params = {
            name: name
          }
  
          return perform_create(params) if options.nil?
          valid_param?(:options, options, Hash, true)
  
          if options.key?(:application_type) &&
             valid_param?(:application_type, options[:application_type], String, true)
            params[:application_type] = options[:application_type]
          end
  
          if options.key?(:application_id) &&
            valid_param?(:application_id, options[:application_id], String, true)
           params[:application_id] = options[:application_id]
         end
  
          if options.key?(:sticky_sender) &&
             valid_param?(:sticky_sender, options[:sticky_sender], [TrueClass, FalseClass], true)
            params[:sticky_sender] = options[:sticky_sender]
          end

          if options.key?(:local_connect) &&
            valid_param?(:local_connect, options[:local_connect], [TrueClass, FalseClass], true)
           params[:local_connect] = options[:local_connect]
         end

          if options.key?(:number_priority) &&
             valid_param?(:number_priority, options[:number_priority], Array, true)
            params[:number_priority] = options[:number_priority]
          end

          perform_create(params)
        end
  
        def get(uuid)
          valid_param?(:uuid, uuid, [String, Symbol], true)
          perform_get(uuid)
        end
        
        def list(options = nil)
          return perform_list if options.nil?
          params = {}
          %i[offset limit].each do |param|
            if options.key?(param) && valid_param?(param, options[param],
                                                   [Integer, Integer], true)
              params[param] = options[param]
            end
          end
  
          if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
            raise_invalid_request('The maximum number of results that can be '\
            "fetched is 20. limit can't be more than 20 or less than 1")
          end
  
          if options.key?(:offset) && options[:offset] < 0
            raise_invalid_request("Offset can't be negative")
          end
          perform_list(params)
        end

        def each
          offset = 0
          loop do
            powerpack_list = list(offset: offset)
            powerpack_list[:objects].each { |message| yield message }
            offset += 20
            return unless powerpack_list.length == 20
          end
        end

      end
  end

end
