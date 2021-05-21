require 'rubygems'
require 'plivo'

include Plivo

AUTH_ID = 'MADADADADADADADADADA'
AUTH_TOKEN = 'AUTH_TOKEN'

begin
  acctkn = Plivo::Token::AccessToken.new(
    AUTH_ID,
    AUTH_TOKEN,
    '{username}',
    '{uid}'
  )
  # update token validity (from, lifetime)
  acctkn.update_validity(Time.now, 300)
  # add voice grants (incoming, outgoing)
  acctkn.add_voice_grants(Plivo::Token::VoiceGrants.new(true, true))
  puts acctkn.to_jwt

  # update token validity (from, nil, till)
  acctkn.update_validity(Time.now, nil, Time.now + 300)
  # add voice grants (incoming, outgoing)
  acctkn.add_voice_grants(Plivo::Token::VoiceGrants.new(true, true))
  puts acctkn.to_jwt
rescue ValidationError => e
  puts 'Exception: ' + e.message
end

# Sample Response:
#
