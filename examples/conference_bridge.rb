require 'rubygems'
require 'plivo'

include Plivo

AUTH_ID = 'AUTH_ID'
AUTH_TOKEN = 'AUTH_TOKEN'

client = Phlo.new(AUTH_ID, AUTH_TOKEN)

# if credentials are stored in the PLIVO_AUTH_ID and the PLIVO_AUTH_TOKEN environment variables
# then initialize client as:
# client = Phlo.new
#

# provide the phlo_id in params
begin
  phlo = client.phlo.get('11a5f5cf-b6cd-419b-8ada-e41ef073de74')
  conference_bridge = phlo.conference_bridge('b24d49ea-fb62-4612-9d98-4565c67f0bdc')
  puts conference_bridge
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end

# Response:
# {
#   "api_id"=>"1bcee5a2-f2db-47c3-b424-49f09bc9c62a",
#   "node_id"=>"b24d49ea-fb62-4612-9d98-4565c67f0bdc",
#   "phlo_id"=>"11a5f5cf-b6cd-419b-8ada-e41ef073de74",
#   "name"=>"Conference_1",
#   "node_type"=>"conference",
#   "created_on"=>"2018-12-04 13:51:22.796041+00:00"
# }



# 1. member leaves the call [HANGUP]:
#
# member_address => phone number of the member
#
# conference_bridge.member(<member_address>).hangup

begin
  response = conference_bridge.member('0000000000').hangup
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end

# Response:
# {
#   "api_id"=>"1bcee5a2-f2db-47c3-b424-49f09bc9c62a",
#   "node_id"=>"b24d49ea-fb62-4612-9d98-4565c67f0bdc",
#   "phlo_id"=>"11a5f5cf-b6cd-419b-8ada-e41ef073de74",
#   "member_address"=>"0000000000",
#   "node_type"=>"conference",
#   "created_on"=>"2018-12-04 13:51:22.796041+00:00"
# }



# 2. Mute a member in the conference bridge:
#
# member_address => phone number of the member
#
# conference_bridge.member(<member_address>).mute

begin
  response = conference_bridge.member('0000000000').mute
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end

# Response:
# {
#   "api_id"=>"1bcee5a2-f2db-47c3-b424-49f09bc9c62a",
#   "node_id"=>"b24d49ea-fb62-4612-9d98-4565c67f0bdc",
#   "phlo_id"=>"11a5f5cf-b6cd-419b-8ada-e41ef073de74",
#   "member_address"=>"0000000000",
#   "node_type"=>"conference",
#   "created_on"=>"2018-12-04 13:51:22.796041+00:00"
# }



# 3. Unmute a member in the conference bridge:
#
# member_address => phone number of the member
#
# conference_bridge.member(<member_address>).unmute

begin
  response = conference_bridge.member('0000000000').unmute
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end

# Response:
# {
#   "api_id"=>"1bcee5a2-f2db-47c3-b424-49f09bc9c62a",
#   "node_id"=>"b24d49ea-fb62-4612-9d98-4565c67f0bdc",
#   "phlo_id"=>"11a5f5cf-b6cd-419b-8ada-e41ef073de74",
#   "member_address"=>"0000000000",
#   "node_type"=>"conference",
#   "created_on"=>"2018-12-04 13:51:22.796041+00:00"
# }