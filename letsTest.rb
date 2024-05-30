class SessionParser
  def initialize(identifier_string = 'session_uuid')
    @_identifier_string = identifier_string
  end

  def parse_and_set(resource_json)
    return unless resource_json.is_a?(Hash)

    set_instance_variables(resource_json)

    if @_identifier_string && resource_json.key?(@_identifier_string)
      @id = resource_json[@_identifier_string]
    end
  end

  private

  def set_instance_variables(hash)
    hash.each do |k, v|
      instance_var_name = "@#{k}"

      if v.is_a?(Hash)
        instance_variable_set(instance_var_name, v)
        self.class.send(:attr_reader, k.to_sym)
        v.each do |nested_k, nested_v|
          instance_var_name = "@#{nested_k}"
          instance_variable_set(instance_var_name, nested_v)
          self.class.send(:attr_reader, nested_k.to_sym)
        end
      else
        instance_variable_set(instance_var_name, v)
        self.class.send(:attr_reader, k.to_sym)
      end
    end
  end
end

# Test the class
parser = SessionParser.new
api_response = {
  "api_id" => "11b2ec97-69c1-4c16-9bf9-7a7f78cf0089",
  "message" => "Session updated",
  "session" => {
    "first_party" => "917708772011",
    "second_party" => "918220568648",
    "virtual_number" => "912235328980",
    "status" => "active",
    "initiate_call_to_first_party" => true,
    "session_uuid" => "852d7488-3901-4aa9-a385-8880c485b8c4",
    "callback_url" => "http://plivobin.non-prod.plivops.com/1jvpmrs1",
    "callback_method" => "GET",
    "created_time" => "2024-05-30 03:32:11 +0000 UTC",
    "modified_time" => "2024-05-30 03:35:14 +0000 UTC",
    "expiry_time" => "2024-05-30 08:08:34 +0000 UTC",
    "duration" => 16583,
    "amount" => 0,
    "call_time_limit" => 14400,
    "ring_timeout" => 120,
    "first_party_play_url" => "https://s3.amazonaws.com/plivosamplexml/first.xml",
    "second_party_play_url" => "https://plivobin-prod-usw.plivops.com/api/v1/second.xml",
    "record" => false,
    "record_file_format" => "mp3",
    "recording_callback_url" => "https://plivobin-prod-usw.plivops.com/api/v1/speak.xml",
    "recording_callback_method" => "GET",
    "interaction" => [
      {
        "start_time" => "2024-05-30 03:32:12 +0000 UTC",
        "end_time" => "2024-05-30 03:32:32 +0000 UTC",
        "first_party_resource_url" => "https://api.plivo.com/v1/Account/MAMTHKYJU2ZJQYMDG0YT/Call/c5a49c13-8d6d-4230-b622-042917ce1874",
        "second_party_resource_url" => "https://api.plivo.com/v1/Account/MAMTHKYJU2ZJQYMDG0YT/Call/63976ad7-9287-4d6b-b66a-54d6db77cca5",
        "type" => "call",
        "total_call_amount" => 0.033,
        "call_billed_duration" => 60,
        "total_call_count" => 2,
        "duration" => 29
      }
    ],
    "total_call_amount" => 0.033,
    "total_call_count" => 2,
    "total_call_billed_duration" => 60,
    "total_session_amount" => 0.033,
    "last_interaction_time" => "2024-05-30 03:32:32 +0000 UTC",
    "unknown_caller_play" => "https://vinodhan-test.s3.amazonaws.com/Number+masking+audio/2024-02-13-201825_178983233.mp3",
    "is_pin_authentication_required" => false,
    "generate_pin" => nil,
    "generate_pin_length" => nil,
    "first_party_pin" => nil,
    "second_party_pin" => nil,
    "pin_prompt_play" => nil,
    "pin_retry" => nil,
    "pin_retry_wait" => nil,
    "incorrect_pin_play" => nil
  }
}

parser.parse_and_set(api_response)
puts parser.instance_variables.map { |var| [var, parser.instance_variable_get(var)] }.to_h
