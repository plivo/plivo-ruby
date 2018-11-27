require 'plivo'
require 'plivo'

include Plivo

AUTH_ID = 'AUTH_ID'
AUTH_TOKEN = 'AUH_TOKEN'

client = Phlo.new(AUTH_ID, AUTH_TOKEN)

# if credentials are stored in the PLIVO_AUTH_ID and the PLIVO_AUTH_TOKEN environment variables
# then initialize client as:
# client = Plivo::Phlo.new
#

# provide the phlo_id in params
phlo = client.phlo.get('phlo_id')

# initiate phlo via API request:

phlo.run()

