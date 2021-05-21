require "rubygems"
require "plivo"

include Plivo
include Plivo::Exceptions

AUTH_ID = ""
AUTH_TOKEN = ""

client = RestClient.new(AUTH_ID, AUTH_TOKEN)

# if credentials are stored in the PLIVO_AUTH_ID and the PLIVO_AUTH_TOKEN environment variables
# then initialize client as:
# client = RestClient.new

begin
  resp = client.lookup.get(
    "<insert-number-here>",
    "carrier"
  )
  puts resp
rescue PlivoRESTError => e
  puts "Exception: " + e.message
end
