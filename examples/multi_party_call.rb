require 'rubygems'
require 'plivo'

include Plivo

AUTH_ID = 'AUTH_ID'
AUTH_TOKEN = 'AUTH_TOKEN'

client = Phlo.new(AUTH_ID, AUTH_TOKEN)

# if credentials are stored in the PLIVO_AUTH_ID and the PLIVO_AUTH_TOKEN environment variables
# then initialize client as:
# client = Plivo::Phlo.new
#

# provide the phlo_id in params
phlo = client.phlo.get('phlo_id')

# provide multi_party_call node id in params:
multi_party_call = phlo.multi_party_call('node_id')

# 1. Agent makes outbound call to customer:
#
# 'trigger_source' => Caller Id to be set when an outbound call is made to the users to be added to the multi-party call
# 'to' => 'List of phone numbers and endpoints to which an outbound call should be initiated'
# 'role' => 'customer'/'agent'/'supervisor'
# multi_party_call.call(<trigger_source>, <to>, <role>)

updated_multi_party_call = multi_party_call.call('9999999999', %w(0000000000 8888888888), 'customer')


# 2. Agent initiates warm transfer:
#
# 'trigger_source' => number of the agent initiating warm transfer
# 'to' => number of another agent to be added to the multi-party call
#
# multi_party_call.warm_transfer(<trigger_source>, <to>)

updated_multi_party_call = multi_party_call.warm_transfer('9999999999', '0000000000')


# 3. Agent initiates cold transfer:
#
# 'trigger_source' => number of the agent initiating cold transfer
# 'to' => number of another agent to be added to the multi-party call
#
# multi_party_call.cold_transfer(<trigger_source>, <to>)

updated_multi_party_call = multi_party_call.cold_transfer('9999999999', '0000000000')


# 4. abort transfer:
#
# trigger_source => number of the agent who initiated warm transfer
# to => number of the agent to be aborted from the multi-party call
#
# multi_party_call.abort_transfer(<trigger_source>, <to>)

updated_multi_party_call = multi_party_call.abort_transfer('9999999999', '0000000000')
