require 'rspec'
require 'plivo'
include Plivo::Utils
describe 'XML test' do
  it 'should succeed' do
    resp = Plivo::XML::Response.new

    resp.addConference(
      'My room',
      callbackUrl: 'http://foo.com/confevents/',
      callbackMethod: 'POST',
      digitsMatch: '#0,90,000'
    )

    dial = resp.addDial(confirmSound: 'http://foo.com/sound/',
                        confirmKey: '3')
    dial.addNumber('18217654321',
                   sendDigits: 'wwww2410')
    dial.addUser('sip:john1234@phone.plivo.com',
                 sendDigits: 'wwww2410')

    dial1 = resp.addDial(timeout: '20',
                         action: 'http://foo.com/dial_action/')

    dial1.addNumber('18217654321', {})

    dial2 = resp.addDial({})
    dial2.addNumber('15671234567', {})

    resp.addDTMF('12345', {})

    get_digits =
      resp.addGetDigits(action: 'http://ww.foo.com/gather_pin/',
                        method: 'POST')

    get_digits.addSpeak('Enter PIN number.', {})
    resp.addSpeak('Input not recieved.', {})

    get_input =
        resp.addGetInput(action: 'http://ww.foo.com/gather_feedback/',
                          method: 'POST')

    get_input.addSpeak('Tell us more about your experience.', {})
    resp.addSpeak('Statement not recieved.', {})

    resp.addHangup(schedule: '60',
                   reason: 'rejected')
    resp.addSpeak('Call will hangup after a min.',
                  loop: '0')

    resp.addMessage('Hi, message from Plivo.',
                    src: '12023222222',
                    dst: '15671234567',
                    type: 'sms',
                    callbackUrl: 'http://foo.com/sms_status/',
                    callbackMethod: 'POST')

    resp.addPlay('https://amazonaws.com/Trumpet.mp3', {})

    answer = resp.addPreAnswer
    answer.addSpeak('This call will cost $2 a min.', {})
    resp.addSpeak('Thanks for dropping by.', {})

    resp.addRecord(
      action: 'http://foo.com/get_recording/',
      startOnDialAnswer: 'true',
      redirect: 'false'
    )

    dial3 = resp.addDial({})

    dial3.addNumber('15551234567', {})

    resp.addSpeak('Leave message after the beep.', {})
    resp.addRecord(
      action: 'http://foo.com/get_recording/',
      maxLength: '30',
      finishOnKey: '*'
    )
    resp.addSpeak('Recording not received.', {})

    resp.addSpeak('Your call is being transferred.', {})
    resp.addRedirect('http://foo.com/redirect/', {})

    resp.addSpeak('Go green, go plivo.', loop: '3')

    resp.addSpeak('I will wait 7 seconds starting now!', {})
    resp.addWait(length: '7')
    resp.addSpeak('I just waited 7 seconds.', {})

    resp.addWait(length: '120', beep: 'true')
    resp.addPlay('https://s3.amazonaws.com/abc.mp3', {})

    resp.addWait(length: '10')
    resp.addSpeak('Hello', {})

    resp.addWait(
      length: '10',
      silence: 'true',
      minSilence: '3000'
    )
    resp.addSpeak('Hello, welcome to the Jungle.', {})

    resp.addMultiPartyCall(
        'Nairobi',
        role: 'Agent',
        maxDuration: 1000,
        statusCallbackEvents: 'participant-speak-events, participant-digit-input-events, add-participant-api-events, participant-state-changes, mpc-state-changes'
    )

    resp.addStream('Starting a new stream.')
    resp.addStream('Starting a new stream with params.',
                   {
                     bidirectional: 'true',
                     audioTrack: 'outbound'
                   })

    xml = Plivo::XML::PlivoXML.new(resp)
    puts xml.to_xml
    expect(xml.to_xml).to eql("<?xml version=\"1.0\" encoding=\"utf-8\" ?><Response><Conference callbackMethod='POST' callbackUrl='http://foo.com/confevents/' digitsMatch='#0,90,000'>My room</Conference><Dial confirmKey='3' confirmSound='http://foo.com/sound/'><Number sendDigits='wwww2410'>18217654321</Number><User sendDigits='wwww2410'>sip:john1234@phone.plivo.com</User></Dial><Dial action='http://foo.com/dial_action/' timeout='20'><Number>18217654321</Number></Dial><Dial><Number>15671234567</Number></Dial><DTMF>12345</DTMF><GetDigits action='http://ww.foo.com/gather_pin/' method='POST'><Speak>Enter PIN number.</Speak></GetDigits><Speak>Input not recieved.</Speak><GetInput action='http://ww.foo.com/gather_feedback/' method='POST'><Speak>Tell us more about your experience.</Speak></GetInput><Speak>Statement not recieved.</Speak><Hangup reason='rejected' schedule='60'/><Speak loop='0'>Call will hangup after a min.</Speak><Message callbackMethod='POST' callbackUrl='http://foo.com/sms_status/' dst='15671234567' src='12023222222' type='sms'>Hi, message from Plivo.</Message><Play>https://amazonaws.com/Trumpet.mp3</Play><PreAnswer><Speak>This call will cost $2 a min.</Speak></PreAnswer><Speak>Thanks for dropping by.</Speak><Record action='http://foo.com/get_recording/' redirect='false' startOnDialAnswer='true'/><Dial><Number>15551234567</Number></Dial><Speak>Leave message after the beep.</Speak><Record action='http://foo.com/get_recording/' finishOnKey='*' maxLength='30'/><Speak>Recording not received.</Speak><Speak>Your call is being transferred.</Speak><Redirect>http://foo.com/redirect/</Redirect><Speak loop='3'>Go green, go plivo.</Speak><Speak>I will wait 7 seconds starting now!</Speak><Wait length='7'/><Speak>I just waited 7 seconds.</Speak><Wait beep='true' length='120'/><Play>https://s3.amazonaws.com/abc.mp3</Play><Wait length='10'/><Speak>Hello</Speak><Wait length='10' minSilence='3000' silence='true'/><Speak>Hello, welcome to the Jungle.</Speak><MultiPartyCall agentHoldMusicMethod='GET' coachMode='true' customerHoldMusicMethod='GET' endMpcOnExit='false' enterSound='beep:1' enterSoundMethod='GET' exitSound='beep:2' exitSoundMethod='GET' hold='false' maxDuration='1000' maxParticipants='10' mute='false' onExitActionMethod='POST' record='false' recordFileFormat='mp3' recordMinMemberCount='1' recordingCallbackMethod='GET' relayDTMFInputs='false' role='Agent' startMpcOnEnter='true' startRecordingAudioMethod='GET' statusCallbackEvents='participant-speak-events, participant-digit-input-events, add-participant-api-events, participant-state-changes, mpc-state-changes' statusCallbackMethod='POST' stayAlone='false' stopRecordingAudioMethod='GET' waitMusicMethod='GET'>Nairobi</MultiPartyCall><Stream>Starting a new stream.</Stream><Stream audioTrack='outbound' bidirectional='true'>Starting a new stream with params.</Stream></Response>")
  end
end
