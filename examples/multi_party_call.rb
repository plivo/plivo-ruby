require 'rubygems'
require 'plivo'

include Plivo

AUTH_ID = 'AUTH_ID'
AUTH_TOKEN = 'AUTH_TOKEN'

client = Phlo.new(AUTH_ID, AUTH_TOKEN)

# if credentials are stored in the PLIVO_AUTH_ID and the PLIVO_AUTH_TOKEN environment variables
# then initialize client as:
# client = Phlo.new

# provide the phlo_id in params
phlo = client.phlo.get('phlo_id')

# provide multi_party_call node id in params:
begin
  multi_party_call = phlo.multi_party_call('node_id')
  puts multi_party_call
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end

# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "name": "Multi-Party Call_1",
#   "node_type": "multi_party_call",
#   "phlo_id": 'e564a84a-7910-4447-b16f-65c541dd552c',
#   "created_on": '2018-11-03 19:32:33.240504+00:00'
# }
#------------------------------------------------------------------------

# 1. Agent makes outbound call to customer:
#
# 'trigger_source' => Caller Id to be set when an outbound call is made to the users to be added to the multi-party call
# 'to' => 'phone number/SIP endpoint to which an outbound call should be initiated'
# 'role' => 'customer'/'agent'/'supervisor'
# multi_party_call.call(<trigger_source>, <to>, <role>)

begin
  response = multi_party_call.call('9999999999', '0000000000', 'customer')
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end

# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "name": "Multi-Party Call_1",
#   "node_type": "multi_party_call",
#   "phlo_id": 'e564a84a-7910-4447-b16f-65c541dd552c',
#   "created_on": '2018-11-03 19:32:33.240504+00:00'
# }


# 2. Agent initiates warm transfer:
#
# 'trigger_source' => number of the agent initiating warm transfer
# 'to' => number of another agent to be added to the multi-party call
#
# multi_party_call.warm_transfer(<trigger_source>, <to>)

begin
  response = multi_party_call.warm_transfer('9999999999', '0000000000')
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end

# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "name": "Multi-Party Call_1",
#   "node_type": "multi_party_call",
#   "phlo_id": 'e564a84a-7910-4447-b16f-65c541dd552c',
#   "created_on": '2018-11-03 19:32:33.240504+00:00'
# }


# 3. Agent initiates cold transfer:
#
# 'trigger_source' => number of the agent initiating cold transfer
# 'to' => number of another agent to be added to the multi-party call
#
# multi_party_call.cold_transfer(<trigger_source>, <to>)

begin
  response = multi_party_call.cold_transfer('9999999999', '0000000000')
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end

# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "name": "Multi-Party Call_1",
#   "node_type": "multi_party_call",
#   "phlo_id": 'e564a84a-7910-4447-b16f-65c541dd552c',
#   "created_on": '2018-11-03 19:32:33.240504+00:00'
# }


# 4. Agent abort transfer:
#
# agent_address => number of the agent
#
# multi_party_call.member(<agent_address>).abort_transfer


begin
  response = multi_party_call.member('0000000000').abort_transfer
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end

# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_type": "multi_party_call",
#   "phlo_id": 'e564a84a-7910-4447-b16f-65c541dd552c',
#   "member_address": '0000000000',
#   "created_on": '2018-11-03 19:32:33.240504+00:00'
# }


# 5. Agent places customer on hold:
#
# member_address => phone number of the member who is being put on hold
#
# multi_party_call.member(<member_address>).hold

begin
  response = multi_party_call.member('9999999999').hold
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end

# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_type": "multi_party_call",
#   "phlo_id": 'e564a84a-7910-4447-b16f-65c541dd552c',
#   "member_address": '9999999999',
#   "created_on": '2018-11-03 19:32:33.240504+00:00'
# }


# 6. Resume call after hold:
#
# member_address => phone number of the member
#
# multi_party_call.member(<member_address>).unhold

begin
  response = multi_party_call.member('9999999999').unhold
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end


# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_type": "multi_party_call",
#   "phlo_id": 'e564a84a-7910-4447-b16f-65c541dd552c',
#   "member_address": '9999999999',
#   "created_on": '2018-11-03 19:32:33.240504+00:00'
# }


# 7. Agent initiates voicemail drop:
#
# member_address => customer's number/endpoint
#
# multi_party_call.member(<member_address>).voicemail_drop

begin
  response = multi_party_call.member('9999999999').voicemail_drop
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end


# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_type": "multi_party_call",
#   "phlo_id": 'e564a84a-7910-4447-b16f-65c541dd552c',
#   "member_address": '9999999999',
#   "created_on": '2018-11-03 19:32:33.240504+00:00'
# }


# 8. Rejoin call on warm transfer:
#
# agent_address => number of the agent to be added to the original conference on completion of call between agents
#
# multi_party_call.member(<agent_address>).resume_call

begin
  response = multi_party_call.member('0000000000').resume_call
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end


# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_type": "multi_party_call",
#   "phlo_id": 'e564a84a-7910-4447-b16f-65c541dd552c',
#   "member_address": '9999999999',
#   "created_on": '2018-11-03 19:32:33.240504+00:00'
# }


# 9. Agent leaves of the call [HANGUP]:
#
# agent_address => phone number of the agent
#
# multi_party_call.member(<agent_address>).hangup

begin
  response = multi_party_call.member('0000000000').hangup
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end


# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_type": "multi_party_call",
#   "phlo_id": 'e564a84a-7910-4447-b16f-65c541dd552c',
#   "member_address": '9999999999',
#   "created_on": '2018-11-03 19:32:33.240504+00:00'
# }


# 10. Customer is removed from the conference call [HANGUP]:
#
# customer_address => phone number of the customer
#
# multi_party_call.member(<customer_address>).hangup

# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "node_type": "multi_party_call",
#   "phlo_id": 'e564a84a-7910-4447-b16f-65c541dd552c',
#   "member_address": '9999999999',
#   "created_on": '2018-11-03 19:32:33.240504+00:00'
# }


# 11. Remove a member from the multi-party call:
#
# member_address => phone number of the member
#
# multi_party_call.member(<member_address>).remove

begin
  response = multi_party_call.member('9999999999').remove
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end

# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "id": "9999999999"
# }
