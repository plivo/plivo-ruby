require 'rspec'
require 'plivo'

describe 'Jwt test' do
  it 'should succeed' do
    acctkn = Plivo::Token::AccessToken.new(
      'MADADADADADADADADADA',
      'qwerty',
      'username',
      'username-12345'
    )
    acctkn.update_validity(12121212, nil, 12121512)
    acctkn.add_voice_grants(Plivo::Token::VoiceGrants.new(true, true))
    expect(acctkn.to_jwt).to eql('eyJ0eXAiOiJKV1QiLCJjdHkiOiJwbGl2bzt2PTEiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJ1c2VybmFtZS0xMjM0NSIsInN1YiI6InVzZXJuYW1lIiwiaXNzIjoiTUFEQURBREFEQURBREFEQURBREEiLCJuYmYiOjEyMTIxMjEyLCJleHAiOjEyMTIxNTEyLCJncmFudHMiOnsidm9pY2UiOnsiaW5jb21pbmdfYWxsb3ciOnRydWUsIm91dGdvaW5nX2FsbG93Ijp0cnVlfX19.9DchOxw0llIy5bOrXCcbQ5NVQoy2S5480zGzihPK9l8')
  end

  it 'rejects scoped API tokens' do
    expect { Plivo::Token::AccessToken.new('MADADADADADADADADADA', 'PLV' + 'A' * 43, 'username', 'username-12345') }
      .to raise_error(Plivo::Exceptions::AuthenticationError, /scoped API tokens/)
    expect { Plivo::Token::AccessToken.new('MADADADADADADADADADA', 'qwerty', 'username', 'username-12345') }
      .not_to raise_error
  end
end
