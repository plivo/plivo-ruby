module Plivo
    module Resources
      include Plivo::Utils
  
      class Powerpack < Base::Resource
        def initialize(client, options = nil)
          @_name = 'Powerpack'
          @_identifier_string = 'uuid'
          super
        end
          
        def delete(unrent_numbers = false)
            valid_param?(:unrent_numbers, unrent_numbers, [TrueClass, FalseClass],
              false, [true, false])
            
            params = {
              :unrent_numbers => unrent_numbers
            }
            perform_delete(params)
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
          
          perform_update(params)
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
            created_on:@created_on
          }.to_s
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
             valid_param?(:application_type, options[:application_type], String, true, 'sms')
            params[:application_type] = options[:application_type]
          end
  
          if options.key?(:application_id) &&
            valid_param?(:application_id, options[:application_id], String, true, 'sms')
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
          perform_create(params)
        end
  

        def update(uuid, options = nil)
          valid_param?(:uuid, uuid, [String, Symbol], true)
          Powerpack.new(@_client,
                          resource_id: uuid).update(options)
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
  
        def delete(uuid, unrent_numbers = false)
            Powerpack.new(@_client, resource_id: uuid).delete(unrent_numbers)
        end

        def getnumberpool_uuid(uuid)
          valid_param?(:uuid, uuid, [String, Symbol], true)
          response = perform_get(uuid)
          numberpool_path = response.number_pool
          numberpool_array = numberpool_path.split("/")
          numberpool_array[5]
        end

        def removenumber(uuid, number, unrent= false)
          numbe_rpool_uuid = getnumberpool_uuid(uuid)
          perform_action('NumberPool/' + numbe_rpool_uuid.join(',') + '/Number/' + number.to_s ,
                       'DELETE', { unrent: unrent }, false)
        end

        def addnumber(uuid, number)
          numbe_rpool_uuid = getnumberpool_uuid(uuid)
          perform_action('NumberPool/' + numbe_rpool_uuid.join(',') + '/Number/' + number.to_s ,
                       'POST')
        end

        def findnumber(uuid, number)
          numbe_rpool_uuid = getnumberpool_uuid(uuid)
          perform_action('NumberPool/' + numbe_rpool_uuid.join(',') + '/Number/' + number.to_s ,
                       'GET')
        end

        def findshortcode(uuid, shortcode)
          numbe_rpool_uuid = getnumberpool_uuid(uuid)
          perform_action('NumberPool/' + numbe_rpool_uuid.join(',') + '/Shortcode/' + shortcode.to_s ,
                       'GET')
        end

        def listshortoce(uuid, options = nil)
          numbe_rpool_uuid = getnumberpool_uuid(uuid)
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
          perform_action('NumberPool/' + numbe_rpool_uuid.join(',') + '/Shortcode',
                       'GET')

        end

        def listnumber(uuid,options = nil)
          numbe_rpool_uuid = getnumberpool_uuid(uuid)
          return perform_action('NumberPool/' + numbe_rpool_uuid.join(',') + '/Number',
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
            valid_param?(:pattern, options[:pattern], String, true, 'sms')
           params[:starts_with] = options[:pattern]
          end
          if options.key?(:country_iso2) &&
            valid_param?(:country_iso2, options[:country_iso2], String, true, 'sms')
           params[:country_iso2] = options[:country_iso2]
          end
          if options.key?(:type) &&
            valid_param?(:type, options[:type], String, true, 'sms')
           params[:type] = options[:type]
          end
          perform_action('NumberPool/' + numbe_rpool_uuid.join(',') + '/Number',
          'GET', param, true)
        end

        def count_number(uuid, options = nil)
          numbe_rpool_uuid = getnumberpool_uuid(uuid)
          if options.nil?
           response = perform_action('NumberPool/' + numbe_rpool_uuid.join(',') + '/Number',
           'GET')
           meta = response.meta
           meta.total_count
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
            valid_param?(:pattern, options[:pattern], String, true, 'sms')
           params[:starts_with] = options[:pattern]
          end
          if options.key?(:country_iso2) &&
            valid_param?(:country_iso2, options[:country_iso2], String, true, 'sms')
           params[:country_iso2] = options[:country_iso2]
          end
          if options.key?(:type) &&
            valid_param?(:type, options[:type], String, true, 'sms')
           params[:type] = options[:type]
          end
          reponse = perform_action('NumberPool/' + numbe_rpool_uuid.join(',') + '/Number',
          'GET', param, true)
          meta = response[:meta]
          meta[:total_count]
        end

        def buyandaddnumber(uuid, options = nil)
          numbe_rpool_uuid = getnumberpool_uuid(uuid)
          if options.key?(:number)
            return perform_action('NumberPool/' + numbe_rpool_uuid.join(',') + '/Number/' + options[:number].to_s ,
                       'POST')
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
            valid_param?(:pattern, options[:pattern], String, true, 'sms')
           params[:starts_with] = options[:pattern]
          end
          if options.key?(:country_iso2) &&
            valid_param?(:country_iso2, options[:country_iso2], String, true, 'sms')
           params[:country_iso2] = options[:country_iso2]
          end
          if options.key?(:type) &&
            valid_param?(:type, options[:type], String, true, 'sms')
           params[:type] = options[:type]
          end

         response = perform_action('PhoneNumber',
         'GET', param, true)
          numbers = response[:objects][0][:number]
          perform_action('NumberPool/' + numbe_rpool_uuid.join(',') + '/Number/' + numbers.to_s ,
                       'POST')
        end
    end
  end
  