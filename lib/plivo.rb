require 'rubygems'
require 'restclient'
require 'json'
require 'rexml/document'
require 'htmlentities'
require 'openssl'
require 'base64'

module Plivo
    class PlivoError < StandardError
    end

    class XPlivoSignature
        attr_accessor :signature, :uri, :post_params, :auth_token

        def initialize(signature, uri, post_params, auth_token)
            @signature = signature
            @uri = uri
            @post_params = post_params
            @auth_token = auth_token
        end

        def is_valid?
            uri = @post_params.sort.reduce(@uri) {|_, (key, val)| _ += key + val}
            return Base64.encode64(OpenSSL::HMAC.digest('sha1', @auth_token, uri)).chomp.eql? @signature
        end

    end

    class RestAPI
        attr_accessor :auth_id, :auth_token, :url, :version, :api, :headers, :rest

        def initialize(auth_id, auth_token, url="https://api.plivo.com", version="v1")
            @auth_id = auth_id
            @auth_token = auth_token
            @url = url.chomp('/')
            @version = version
            @api = @url + '/' + @version + '/Account/' + @auth_id
            @headers = {"User-Agent" => "RubyPlivo"}
            @rest = RestClient::Resource.new(@api, @auth_id, @auth_token)
        end

        def hash_to_params(myhash)
            return myhash.map { |k, v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join("&")
        end

        def request(method, path, params=nil)
            if method == "POST"
                if not params
                    params = {}
                end
                begin
                    r = @rest[path].post params.to_json, :content_type => 'application/json'
                rescue => e
                    response = e
                end
                if not response
                    code = r.code
                    raw = r.to_str
                    response = JSON.parse(raw)
                else
                    code = response.http_code
                    response = JSON.parse(response.response.to_s)
                end
                return [code, response]
            elsif method == "GET"
                if params
                    path = path + '?' + hash_to_params(params)
                end

                begin
                    r = @rest[path].get
                rescue => e
                    response = e
                end
                if not response
                    code = r.code
                    raw = r.to_str
                    response = JSON.parse(raw)
                else
                    code = response.http_code
                    response = JSON.parse(response.response.to_s)
                end
                return [code, response]
            elsif method == "DELETE"
                if params
                    path = path + '?' + hash_to_params(params)
                end
                begin
                    r = @rest[path].delete
                rescue => e
                    response = e
                end
                if not response
                    code = r.code
                else
                    code = response.http_code
                    response = JSON.parse(response.response.to_s)
                end
                return [code, ""]
            end
            return [405, 'Method Not Supported']
        end

        ## Accounts ##
        def get_account(params={})
            return request('GET', "/", params)
        end

        def modify_account(params={})
            return request('POST', "/", params)
        end

        def get_subaccounts(params={})
            return request('GET', "/Subaccount/", params)
        end

        def create_subaccount(params={})
            return request('POST', "/Subaccount/", params)
        end

        def get_subaccount(params={})
            subauth_id = params.delete("subauth_id") || params.delete(:subauth_id)
            return request('GET', "/Subaccount/#{subauth_id}/", params)
        end

        def modify_subaccount(params={})
            subauth_id = params.delete("subauth_id") || params.delete(:subauth_id)
            return request('POST', "/Subaccount/#{subauth_id}/", params)
        end

        def delete_subaccount(params={})
            subauth_id = params.delete("subauth_id") || params.delete(:subauth_id)
            return request('DELETE', "/Subaccount/#{subauth_id}/", params)
        end

        ## Applications ##
        def get_applications(params={})
            return request('GET', "/Application/", params)
        end

        def create_application(params={})
            return request('POST', "/Application/", params)
        end

        def get_application(params={})
            app_id = params.delete("app_id")
            return request('GET', "/Application/#{app_id}/", params)
        end

        def modify_application(params={})
            app_id = params.delete("app_id")
            return request('POST', "/Application/#{app_id}/", params)
        end

        def delete_application(params={})
            app_id = params.delete("app_id")
            return request('DELETE', "/Application/#{app_id}/", params)
        end

        ## Numbers ##
        def search_phone_number(params={})
            return request('GET', "/PhoneNumber/", params)
        end

        def buy_phone_number(params={})
            number = params.delete("number")
            return request('POST', "/PhoneNumber/#{number}/", params)
        end

        def get_numbers(params={})
            return request('GET', "/Number/", params)
        end

        def modify_number(params={})
            number = params.delete("number")
            return request('POST', "/Number/#{number}/", params)
        end

        def search_numbers(params={})
            return request('GET', "/AvailableNumber/", params)
        end

        def get_number(params={})
            number = params.delete("number")
            return request('GET', "/Number/#{number}/", params)
        end

        def rent_number(params={})
            number = params.delete("number")
            return request('POST', "/AvailableNumber/#{number}/", params)
        end

        def unrent_number(params={})
            number = params.delete("number")
            return request('DELETE', "/Number/#{number}/", params)
        end

        def link_application_number(params={})
            number = params.delete("number")
            return request('POST', "/Number/#{number}/", params)
        end

        def unlink_application_number(params={})
            number = params.delete("number")
            params = {"app_id" => ""}
            return request('POST', "/Number/#{number}/", params)
        end

        def get_number_group(params={})
            return request('GET', "/AvailableNumberGroup/", params)
        end

        def get_number_group_details(params={})
            group_id = params.delete('group_id')
            return request('GET', "/AvailableNumberGroup/#{group_id}/", params)
        end

        def rent_from_number_group(params={})
            group_id = params.delete('group_id')
            return request('POST', "/AvailableNumberGroup/#{group_id}/", params)
        end

        ## Calls ##
        def get_cdrs(params={})
            return request('GET', "/Call/", params)
        end

        def get_cdr(params={})
            record_id = params.delete('record_id')
            return request('GET', "/Call/#{record_id}/", params)
        end

        def get_live_calls(params={})
            params["status"] = "live"
            return request('GET', "/Call/", params)
        end

        def get_live_call(params={})
            call_uuid = params.delete('call_uuid')
            params["status"] = "live"
            return request('GET', "/Call/#{call_uuid}/", params)
        end

        def make_call(params={})
            return request('POST', "/Call/", params)
        end

        def hangup_all_calls(params={})
            return request('DELETE', "/Call/", params)
        end

        def transfer_call(params={})
            call_uuid = params.delete('call_uuid')
            return request('POST', "/Call/#{call_uuid}/", params)
        end

        def hangup_call(params={})
            call_uuid = params.delete('call_uuid')
            return request('DELETE', "/Call/#{call_uuid}/", params)
        end

        def record(params={})
            call_uuid = params.delete('call_uuid')
            return request('POST', "/Call/#{call_uuid}/Record/", params)
        end

        def stop_record(params={})
            call_uuid = params.delete('call_uuid')
            return request('DELETE', "/Call/#{call_uuid}/Record/", params)
        end

        def play(params={})
            call_uuid = params.delete('call_uuid')
            return request('POST', "/Call/#{call_uuid}/Play/", params)
        end

        def stop_play(params={})
            call_uuid = params.delete('call_uuid')
            return request('DELETE', "/Call/#{call_uuid}/Play/", params)
        end

        def speak(params={})
            call_uuid = params.delete('call_uuid')
            params.update({"text" => HTMLEntities.new(:html4).encode(params['text'], :decimal)})
            return request('POST', "/Call/#{call_uuid}/Speak/", params)
        end

        def stop_speak(params={})
            call_uuid = params.delete('call_uuid')
            return request('DELETE', "/Call/#{call_uuid}/Speak/", params)
        end

        def send_digits(params={})
            call_uuid = params.delete('call_uuid')
            return request('POST', "/Call/#{call_uuid}/DTMF/", params)
        end

        ## Calls requests ##
        def hangup_request(params={})
            request_uuid = params.delete('request_uuid')
            return request('DELETE', "/Request/#{request_uuid}/", params)
        end

        ## Conferences ##
        def get_live_conferences(params={})
            return request('GET', "/Conference/", params)
        end

        def hangup_all_conferences(params={})
            return request('DELETE', "/Conference/", params)
        end

        def get_live_conference(params={})
            conference_name = params.delete('conference_name')
            return request('GET', "/Conference/#{conference_name}/", params)
        end

        def hangup_conference(params={})
            conference_name = params.delete('conference_name')
            return request('DELETE', "/Conference/#{conference_name}/", params)
        end

        def hangup_member(params={})
            conference_name = params.delete('conference_name')
            member_id = params.delete('member_id')
            return request('DELETE', "/Conference/#{conference_name}/Member/#{member_id}/", params)
        end

        def play_member(params={})
            conference_name = params.delete('conference_name')
            member_id = params.delete('member_id')
            return request('POST', "/Conference/#{conference_name}/Member/#{member_id}/Play/", params)
        end

        def stop_play_member(params={})
            conference_name = params.delete('conference_name')
            member_id = params.delete('member_id')
            return request('DELETE', "/Conference/#{conference_name}/Member/#{member_id}/Play/", params)
        end

        def speak_member(params={})
            conference_name = params.delete('conference_name')
            member_id = params.delete('member_id')
            params.update({"text" => HTMLEntities.new(:html4).encode(params['text'], :decimal)})
            return request('POST', "/Conference/#{conference_name}/Member/#{member_id}/Speak/", params)
        end

        def stop_speak_member(params={})
            conference_name = params.delete('conference_name')
            member_id = params.delete('member_id')
            return request('DELETE', "/Conference/#{conference_name}/Member/#{member_id}/Speak/", params)
        end

        def deaf_member(params={})
            conference_name = params.delete('conference_name')
            member_id = params.delete('member_id')
            return request('POST', "/Conference/#{conference_name}/Member/#{member_id}/Deaf/", params)
        end

        def undeaf_member(params={})
            conference_name = params.delete('conference_name')
            member_id = params.delete('member_id')
            return request('DELETE', "/Conference/#{conference_name}/Member/#{member_id}/Deaf/", params)
        end

        def mute_member(params={})
            conference_name = params.delete('conference_name')
            member_id = params.delete('member_id')
            return request('POST', "/Conference/#{conference_name}/Member/#{member_id}/Mute/", params)
        end

        def unmute_member(params={})
            conference_name = params.delete('conference_name')
            member_id = params.delete('member_id')
            return request('DELETE', "/Conference/#{conference_name}/Member/#{member_id}/Mute/", params)
        end

        def kick_member(params={})
            conference_name = params.delete('conference_name')
            member_id = params.delete('member_id')
            return request('POST', "/Conference/#{conference_name}/Member/#{member_id}/Kick/", params)
        end

        def record_conference(params={})
            conference_name = params.delete('conference_name')
            return request('POST', "/Conference/#{conference_name}/Record/", params)
        end

        def stop_record_conference(params={})
            conference_name = params.delete('conference_name')
            return request('DELETE', "/Conference/#{conference_name}/Record/", params)
        end

        ## Recordings ##
        def get_recordings(params={})
            return request('GET', "/Recording/", params)
        end

        def get_recording(params={})
            recording_id = params.delete('recording_id')
            return request('GET', "/Recording/#{recording_id}/", params)
        end

        def delete_recording(params={})
            recording_id = params.delete('recording_id')
            return request('DELETE', "/Recording/#{recording_id}/", params)
        end

        ## Endpoints ##
        def get_endpoints(params={})
            return request('GET', "/Endpoint/", params)
        end

        def create_endpoint(params={})
            return request('POST', "/Endpoint/", params)
        end

        def get_endpoint(params={})
            endpoint_id = params.delete('endpoint_id')
            return request('GET', "/Endpoint/#{endpoint_id}/", params)
        end

        def modify_endpoint(params={})
            endpoint_id = params.delete('endpoint_id')
            return request('POST', "/Endpoint/#{endpoint_id}/", params)
        end

        def delete_endpoint(params={})
            endpoint_id = params.delete('endpoint_id')
            return request('DELETE', "/Endpoint/#{endpoint_id}/", params)
        end

        ## Incoming Carriers ##
        def get_incoming_carriers(params={})
            return request('GET', "/IncomingCarrier/", params)
        end

        def create_incoming_carrier(params={})
            return request('POST', "/IncomingCarrier/", params)
        end

        def get_incoming_carrier(params={})
            carrier_id = params.delete('carrier_id')
            return request('GET', "/IncomingCarrier/#{carrier_id}/", params)
        end

        def modify_incoming_carrier(params={})
            carrier_id = params.delete('carrier_id')
            return request('POST', "/IncomingCarrier/#{carrier_id}/", params)
        end

        def delete_incoming_carrier(params={})
            carrier_id = params.delete('carrier_id')
            return request('DELETE', "/IncomingCarrier/#{carrier_id}/", params)
        end

        ## Outgoing Carriers ##
        def get_outgoing_carriers(params={})
            return request('GET', "/OutgoingCarrier/", params)
        end

        def create_outgoing_carrier(params={})
            return request('POST', "/OutgoingCarrier/", params)
        end

        def get_outgoing_carrier(params={})
            carrier_id = params.delete('carrier_id')
            return request('GET', "/OutgoingCarrier/#{carrier_id}/", params)
        end

        def modify_outgoing_carrier(params={})
            carrier_id = params.delete('carrier_id')
            return request('POST', "/OutgoingCarrier/#{carrier_id}/", params)
        end

        def delete_outgoing_carrier(params={})
            carrier_id = params.delete('carrier_id')
            return request('DELETE', "/OutgoingCarrier/#{carrier_id}/", params)
        end

        ## Outgoing Carrier Routings ##
        def get_outgoing_carrier_routings(params={})
            return request('GET', "/OutgoingCarrierRouting/", params)
        end

        def create_outgoing_carrier_routing(params={})
            return request('POST', "/OutgoingCarrierRouting/", params)
        end

        def get_outgoing_carrier_routing(params={})
            routing_id = params.delete('routing_id')
            return request('GET', "/OutgoingCarrierRouting/#{routing_id}/", params)
        end

        def modify_outgoing_carrier_routing(params={})
            routing_id = params.delete('routing_id')
            return request('POST', "/OutgoingCarrierRouting/#{routing_id}/", params)
        end

        def delete_outgoing_carrier_routing(params={})
            routing_id = params.delete('routing_id')
            return request('DELETE', "/OutgoingCarrierRouting/#{routing_id}/", params)
        end

        ## Pricing ##
        def pricing(params={})
            return request('GET', "/Pricing/", params)
        end

        ## Outgoing Carrier ##

        ## To be added here ##

        ## Message ##
        def send_message(params={})
            return request('POST', "/Message/", params)
        end

        def get_messages(params={})
            return request('GET', "/Message/", params)
        end

        def get_message(params={})
            record_id = params.delete('record_id')
            return request('GET', "/Message/#{record_id}/", params)
        end
    end



    class Element
        class << self
            attr_accessor :valid_attributes, :nestables
        end
        @nestables = []
        @valid_attributes = []

        attr_accessor :node, :name

        def initialize(body=nil, attributes={}, &block)
            @name = self.class.name.split('::')[1]
            @body = body
            @node = REXML::Element.new @name
            attributes.each do |k, v|
                if self.class.valid_attributes.include?(k.to_s)
                    @node.attributes[k.to_s] = convert_value(v)
                else
                    raise PlivoError, "invalid attribute #{k.to_s} for #{@name}"
                end
            end

            if @body
                @node.text = @body
            end

            # Allow for nested "nestable" elements using a code block
            # ie
            # Plivo::Response.new do |r|
            #   r.Dial do |n|
            #     n.Number '+15557779999'
            #   end
            # end
            yield(self) if block_given?
        end

        def method_missing(method, *args, &block)
            # Handle the addElement methods
            method = $1.to_sym if method.to_s =~ /^add(.*)/
                # Add the element
                add(Plivo.const_get(method).new(*args, &block))
        end


        def convert_value(v)
            if v == true
                return "true"
            elsif v == false
                return "false"
            elsif v == nil
                return "none"
            elsif v == "get"
                return "GET"
            elsif v == "post"
                return "POST"
            else
                return v
            end
        end

        def add(element)
            if not element
                raise PlivoError, "invalid element"
            end
            if self.class.nestables.include?(element.name)
                @node.elements << element.node
                return element
            else
                raise PlivoError, "#{element.name} not nestable in #{@name}"
            end
        end

        def to_xml
            return @node.to_s
        end

        def to_s
            return @node.to_s
        end
    end


    class Response < Element
        @nestables = ['Speak', 'Play', 'GetDigits', 'Record', 'Dial', 'Message',
            'Redirect', 'Wait', 'Hangup', 'PreAnswer', 'Conference', 'DTMF']
        @valid_attributes = []

        def initialize()
            super(nil, {})
        end

        def to_xml()
            return '<?xml version="1.0" encoding="utf-8" ?>' + super()
        end

        def to_s()
            return '<?xml version="1.0" encoding="utf-8" ?>' + super()
        end
    end


    class Speak < Element
        @nestables = []
        @valid_attributes = ['voice', 'language', 'loop']

        def initialize(body, attributes={})
            if not body
                raise PlivoError, 'No text set for Speak'
            else
                body = HTMLEntities.new(:html4).encode(body, :decimal)
            end
            super(body, attributes)
        end
    end


    class Play < Element
        @nestables = []
        @valid_attributes = ['loop']

        def initialize(body, attributes={})
            if not body
                raise PlivoError 'No url set for Play'
            end
            super(body, attributes)
        end
    end


    class Wait < Element
        @nestables = []
        @valid_attributes = ['length', 'silence', 'min_silence', 'beep']

        def initialize(attributes={})
            super(nil, attributes)
        end
    end


    class Redirect < Element
        @nestables = []
        @valid_attributes = ['method']

        def initialize(body, attributes={})
            if not body
                raise PlivoError 'No url set for Redirect'
            end
            super(body, attributes)
        end
    end


    class Hangup < Element
        @nestables = []
        @valid_attributes = ['schedule', 'reason']

        def initialize(attributes={})
            super(nil, attributes)
        end
    end


    class GetDigits < Element
        @nestables = ['Speak', 'Play', 'Wait']
        @valid_attributes = ['action', 'method', 'timeout', 'digitTimeout',
            'numDigits', 'retries', 'invalidDigitsSound',
            'validDigits', 'playBeep', 'redirect', "finishOnKey",
            'digitTimeout', 'log']

        def initialize(attributes={}, &block)
            super(nil, attributes, &block)
        end
    end


    class Number < Element
        @nestables = []
        @valid_attributes = ['sendDigits', 'sendOnPreanswer']

        def initialize(body, attributes={})
            if not body
                raise PlivoError, 'No number set for Number'
            end
            super(body, attributes)
        end
    end


    class User < Element
        @nestables = []
        @valid_attributes = ['sendDigits', 'sendOnPreanswer', 'sipHeaders']

        def initialize(body, attributes={})
            if not body
                raise PlivoError, 'No user set for User'
            end
            super(body, attributes)
        end
    end


    class Dial < Element
        @nestables = ['Number', 'User']
        @valid_attributes = ['action','method','timeout','hangupOnStar',
            'timeLimit','callerId', 'callerName', 'confirmSound',
            'dialMusic', 'confirmKey', 'redirect',
            'callbackUrl', 'callbackMethod', 'digitsMatch', 'digitsMatchBLeg',
            'sipHeaders']

        def initialize(attributes={}, &block)
            super(nil, attributes, &block)
        end
    end


    class Conference < Element
        @nestables = []
        @valid_attributes = ['muted','beep','startConferenceOnEnter',
            'endConferenceOnExit','waitSound','enterSound', 'exitSound',
            'timeLimit', 'hangupOnStar', 'maxMembers',
            'record', 'recordFileFormat', 'action', 'method', 'redirect',
            'digitsMatch', 'callbackUrl', 'callbackMethod',
            'stayAlone', 'floorEvent',
            'transcriptionType', 'transcriptionUrl',
            'transcriptionMethod', 'recordWhenAlone', 'relayDTMF']

        def initialize(body, attributes={})
            if not body
                raise PlivoError, 'No conference name set for Conference'
            end
            super(body, attributes)
        end
    end


    class Record < Element
        @nestables = []
        @valid_attributes = ['action', 'method', 'timeout','finishOnKey',
            'maxLength', 'playBeep', 'recordSession',
            'startOnDialAnswer', 'redirect', 'fileFormat',
            'callbackUrl', 'callbackMethod',
            'transcriptionType', 'transcriptionUrl',
            'transcriptionMethod']

        def initialize(attributes={})
            super(nil, attributes)
        end
    end


    class PreAnswer < Element
        @nestables = ['Play', 'Speak', 'GetDigits', 'Wait', 'Redirect', 'Message', 'DTMF']
        @valid_attributes = []

        def initialize(attributes={}, &block)
            super(nil, attributes, &block)
        end
    end


    class Message < Element
        @nestables = []
        @valid_attributes = ['src', 'dst', 'type', 'callbackUrl', 'callbackMethod']

        def initialize(body, attributes={})
            if not body
                raise PlivoError, 'No text set for Message'
            end
            super(body, attributes)
        end
    end

    class DTMF < Element
        @nestables = []
        @valid_attributes = ['async']

        def initialize(body, attributes={})
            if not body
                raise PlivoError, 'No digits set for DTMF'
            end
            super(body, attributes)
        end
    end

end
