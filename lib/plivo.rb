require 'rubygems'
require 'restclient'
require 'json'
require 'rexml/document'

module Plivo
  class PlivoError < Exception
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
          return myhash.map{|k,v| "#{CGI.escape(k)}=#{CGI.escape(v)}"}.join("&")
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
              end
              return [code, ""]
          end
          return [405, 'Method Not Supported']
      end

      ## Accounts ##
      def get_account(params={})
          return request('GET', '/')
      end

      def modify_account(params={})
          return request('POST', '/', params)
      end

      def get_subaccounts(params={})
          return request('GET', '/Subaccount/')
      end

      def create_subaccount(params={})
          return request('POST', '/Subaccount/', params)
      end

      def get_subaccount(params={})
          subauth_id = params.delete("subauth_id")
          return request('GET', '/Subaccount/#{subauth_id}/')
      end

      def modify_subaccount(params={})
          subauth_id = params.delete("subauth_id")
          return request('POST', '/Subaccount/#{subauth_id}/', params)
      end

      def delete_subaccount(params={})
          subauth_id = params.delete("subauth_id")
          return request('DELETE', '/Subaccount/#{subauth_id}/')
      end

      ## Applications ##
      def get_applications(params={})
          return request('GET', '/Application/', params)
      end

      def create_application(params={})
          return request('POST', '/Application/', params)
      end

      def get_application(params={})
          app_id = params.delete("app_id")
          return request('GET', '/Application/#{app_id}/')
      end

      def modify_application(params={})
          app_id = params.delete("app_id")
          return request('POST', '/Application/#{app_id}/', params)
      end

      def delete_application(params={})
          app_id = params.delete("app_id")
          return request('DELETE', '/Application/#{app_id}/')
      end

      ## Numbers ##
      def get_numbers(params={})
          return request('GET', '/Number/', params)
      end

      def search_numbers(params={})
          return request('GET', '/AvailableNumber/', params)
      end

      def get_number(params={})
          number = params.delete("number")
          return request('GET', '/Number/#{number}/')
      end

      def rent_number(params={})
          number = params.delete("number")
          return request('POST', '/AvailableNumber/#{number}/')
      end

      def unrent_number(params={})
          number = params.delete("number")
          return request('DELETE', '/Number/#{number}/')
      end

      def link_application_number(params={})
          number = params.delete("number")
          return request('POST', '/Number/#{number}/', params)
      end

      def unlink_application_number(params={})
          number = params.delete("number")
          params = {"app_id" => ""}
          return request('POST', '/Number/#{number}/', params)
      end

      ## Schedule ##
      def get_scheduled_tasks(params={})
          return request('GET', '/Schedule/')
      end

      def cancel_scheduled_task(params={})
          task_id = params.delete("task_id")
          return request('DELETE', '/Schedule/#{task_id}/')
      end

      ## Calls ##
      def get_cdrs(params={})
          return request('GET', '/Call/', params)
      end

      def get_cdr(params={})
          record_id = params.delete('record_id')
          return request('GET', '/Call/#{record_id}/')
      end

      def get_live_calls(params={})
          return request('GET', '/Call/', params={'status'=>'live'})
      end

      def get_live_call(params={})
          call_uuid = params.delete('call_uuid')
          return request('GET', '/Call/#{call_uuid}/', params={'status'=>'live'})
      end

      def make_call(params={})
          return request('POST', '/Call/', params)
      end

      def hangup_all_calls(params={})
          return request('DELETE', '/Call/')
      end

      def transfer_call(params={})
          call_uuid = params.delete('call_uuid')
          return request('POST', '/Call/#{call_uuid}/', params)
      end

      def hangup_call(params={})
          call_uuid = params.delete('call_uuid')
          return request('DELETE', '/Call/#{call_uuid}/')
      end

      def record(params={})
          call_uuid = params.delete('call_uuid')
          return request('POST', '/Call/#{call_uuid}/Record/', params)
      end
          
      def stop_record(params={})
          call_uuid = params.delete('call_uuid')
          return request('DELETE', '/Call/#{call_uuid}/Record/')
      end

      def play(params={})
          call_uuid = params.delete('call_uuid')
          return request('POST', '/Call/#{call_uuid}/Play/', params)
      end
          
      def stop_play(params={})
          call_uuid = params.delete('call_uuid')
          return request('DELETE', '/Call/#{call_uuid}/Play/')
      end

      def speak(params={})
          call_uuid = params.delete('call_uuid')
          return request('POST', '/Call/#{call_uuid}/Speak/', params)
      end
          
      def send_digits(params={})
          call_uuid = params.delete('call_uuid')
          return request('POST', '/Call/#{call_uuid}/DTMF/', params)
      end

      ## Calls requests ##
      def hangup_request(params={})
          request_uuid = params.delete('request_uuid')
          return request('DELETE', '/Request/#{request_uuid}/')
      end

      ## Conferences ##
      def get_live_conferences(params={})
          return request('GET', '/Conference/', params)
      end

      def hangup_all_conferences(params={})
          return request('DELETE', '/Conference/')
      end

      def get_live_conference(params={})
          conference_name = params.delete('conference_name')
          return request('GET', '/Conference/#{conference_name}/', params)
      end

      def hangup_conference(params={})
          conference_name = params.delete('conference_name')
          return request('DELETE', '/Conference/#{conference_name}/')
      end

      def hangup_member(params={})
          conference_name = params.delete('conference_name')
          member_id = params.delete('member_id')
          return request('DELETE', '/Conference/#{conference_name}/Member/#{member_id}/')
      end

      def play_member(params={})
          conference_name = params.delete('conference_name')
          member_id = params.delete('member_id')
          return request('POST', '/Conference/#{conference_name}/Member/#{member_id}/Play/', params)
      end
          
      def stop_play_member(params={})
          conference_name = params.delete('conference_name')
          member_id = params.delete('member_id')
          return request('DELETE', '/Conference/#{conference_name}/Member/#{member_id}/Play/')
      end

      def speak_member(params={})
          conference_name = params.delete('conference_name')
          member_id = params.delete('member_id')
          return request('POST', '/Conference/#{conference_name}/Member/#{member_id}/Speak/', params)
      end

      def deaf_member(params={})
          conference_name = params.delete('conference_name')
          member_id = params.delete('member_id')
          return request('POST', '/Conference/#{conference_name}/Member/#{member_id}/Deaf/')
      end

      def undeaf_member(params={})
          conference_name = params.delete('conference_name')
          member_id = params.delete('member_id')
          return request('DELETE', '/Conference/#{conference_name}/Member/#{member_id}/Deaf/')
      end

      def mute_member(params={})
          conference_name = params.delete('conference_name')
          member_id = params.delete('member_id')
          return request('POST', '/Conference/#{conference_name}/Member/#{member_id}/Mute/')
      end

      def unmute_member(params={})
          conference_name = params.delete('conference_name')
          member_id = params.delete('member_id')
          return request('DELETE', '/Conference/#{conference_name}/Member/#{member_id}/Mute/')
      end

      def kick_member(params={})
          conference_name = params.delete('conference_name')
          member_id = params.delete('member_id')
          return request('POST', '/Conference/#{conference_name}/Member/#{member_id}/Kick/')
      end

      def record_conference(params={}) 
          conference_name = params.delete('conference_name')
          return request('POST', '/Conference/#{conference_name}/Record/', params)
      end

      def stop_record_conference(params={}) 
          conference_name = params.delete('conference_name')
          return request('DELETE', '/Conference/#{conference_name}/Record/')
      end

      ## Recordings ##
      def get_recordings(params={})
          return request('GET', '/Recording/', params)
      end

      def get_recording(params={})
          recording_id = params.delete('recording_id')
          return request('GET', '/Recording/#{recording_id}/')
      end

      ## Endpoints ##
      def get_endpoints(params={})
          return request('GET', '/Endpoint/', params)
      end

      def create_endpoint(params={})
          return request('POST', '/Endpoint/', params)
      end

      def get_endpoint(params={})
          endpoint_id = params.delete('endpoint_id')
          return request('GET', '/Endpoint/#{endpoint_id}/')
      end

      def modify_endpoint(params={})
          endpoint_id = params.delete('endpoint_id')
          return request('POST', '/Endpoint/#{endpoint_id}/', params)
      end

      def delete_endpoint(params={})
          endpoint_id = params.delete('endpoint_id')
          return request('DELETE', '/Endpoint/#{endpoint_id}/')
      end

      ## Carriers ##
      def get_carriers(params={})
          return request('GET', '/Carrier/', params)
      end

      def create_carrier(params={})
          return request('POST', '/Carrier/', params)
      end

      def get_carrier(params={})
          carrier_id = params.delete('carrier_id')
          return request('GET', '/Carrier/#{carrier_id}/')
      end

      def modify_carrier(params={})
          carrier_id = params.delete('carrier_id')
          return request('POST', '/Carrier/#{carrier_id}/', params)
      end

      def delete_carrier(params={})
          carrier_id = params.delete('carrier_id')
          return request('DELETE', '/Carrier/#{carrier_id}/')
      end

      ## Carrier Routings ##
      def get_carrier_routings(params={})
          return request('GET', '/CarrierRouting/', params)
      end

      def create_carrier_routing(params={})
          return request('POST', '/CarrierRouting/', params)
      end

      def get_carrier_routing(params={})
          routing_id = params.delete('routing_id')
          return request('GET', '/CarrierRouting/#{routing_id}/')
      end

      def modify_carrier_routing(params={})
          routing_id = params.delete('routing_id')
          return request('POST', '/CarrierRouting/#{routing_id}/', params)
      end

      def delete_carrier_routing(params={})
          routing_id = params.delete('routing_id')
          return request('DELETE', '/CarrierRouting/#{routing_id}/')
      end

      ## Message ##
      def send_message(params={})
          return request('POST', '/Message/', params)
      end
  end



  class Element
      class << self 
          attr_accessor :valid_attributes, :nestables
      end 
      @nestables = []
      @valid_attributes = []

      attr_accessor :node, :name

      def initialize(body=nil, attributes={})
          @name = self.class.name.split('::')[1]
          @body = body
          @node = REXML::Element.new @name
          attributes.each do |k, v|
              if self.class.valid_attributes.include?(k)
                  @node.attributes[k] = convert_value(v)
              else
                  raise PlivoError, 'invalid attribute ' + k + ' for ' + @name
              end
          end
          if @body
              @node.text = @body
          end
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
              raise PlivoError, element.name + ' not nestable in ' + @name
          end
      end

      def to_xml
          return @node.to_s
      end

      def to_s
          return @node.to_s
      end

      def addSpeak(body, attributes={})
          return add(Speak.new(body, attributes))
      end

      def addPlay(body, attributes={})
          return add(Play.new(body, attributes))
      end

      def addGetDigits(attributes={})
          return add(GetDigits.new(attributes))
      end

      def addRecord(attributes={})
          return add(Record.new(attributes))
      end

      def addDial(attributes={})
          return add(Dial.new(attributes))
      end

      def addNumber(body, attributes={})
          return add(Number.new(body, attributes))
      end

      def addUser(body, attributes={})
          return add(User.new(body, attributes))
      end

      def addRedirect(body, attributes={})
          return add(Redirect.new(body, attributes))
      end

      def addWait(attributes={})
          return add(Wait.new(attributes))
      end

      def addHangup(attributes={})
          return add(Hangup.new(attributes))
      end

      def addPreAnswer(attributes={})
          return add(PreAnswer.new(attributes))
      end

      def addConference(body, attributes={})
          return add(Conference.new(body, attributes))
      end

      def addMessage(body, attributes={})
          return add(Message.new(body, attributes))
      end

      def addDTMF(body, attributes={})
          return add(DTMF.new(body, attributes))
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
      @valid_attributes = ['length']

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
      @valid_attributes = ['action', 'method', 'timeout', 'finishOnKey',
                          'numDigits', 'retries', 'invalidDigitsSound',
                          'validDigits', 'playBeep', 'redirect']

      def initialize(attributes={})
          super(nil, attributes)
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
                           'callbackUrl', 'callbackMethod', 'digitsMatch',
                           'sipHeaders']

      def initialize(attributes={})
          super(nil, attributes)
      end
  end


  class Conference < Element
      @nestables = []
      @valid_attributes = ['muted','beep','startConferenceOnEnter',
                           'endConferenceOnExit','waitSound','enterSound', 'exitSound',
                           'timeLimit', 'hangupOnStar', 'maxMembers',
                           'record', 'recordFileFormat', 'action', 'method', 'redirect',
                           'digitsMatch', 'callbackUrl', 'callbackMethod',
                           'stayAlone', 'floorEvent']

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
                           'startOnDialAnswer', 'redirect', 'fileFormat']

      def initialize(attributes={})
          super(nil, attributes)
      end
  end


  class PreAnswer < Element
      @nestables = ['Play', 'Speak', 'GetDigits', 'Wait', 'Redirect', 'Message', 'DTMF']
      @valid_attributes = []

      def initialize(attributes={})
          super(nil, attributes)
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
      @valid_attributes = []

      def initialize(body, attributes={})
          if not body
              raise PlivoError, 'No digits set for DTMF'
          end
          super(body, attributes)
      end
  end

end
