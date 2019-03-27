require 'rspec'
require 'plivo'


describe 'SSML elements test' do
  describe 'test for <break>' do
    it 'should succeed for <break> element' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      speak.addBreak(time: '300ms')
      xml = Plivo::XML::PlivoXML.new(resp)
      
      expect(xml.to_xml).to eql("<?xml version=\"1.0\" encoding=\"utf-8\" ?><Response><Speak voice='Polly.Salli'>Test Call<Break time='300ms'/></Speak></Response>")
    end

    it 'should throw exception if wrong attribute value specified for strength attribute' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addBreak(strength: 'invalid')}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'invalid attribute value invalid for strength')
    end

    it 'should throw exception if wrong attribute value specified for time attribute' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addBreak(time: '30')}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'invalid attribute value 30 for time attribute')
    end

    it 'should throw exception if value of time attribute is > 10s' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addBreak(time: '30s')}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'invalid attribute value 30s for time attribute. Value for time in seconds should be > 0 or < 10')
    end
  end

 describe 'test for <emphasis> element' do
   it 'should succeed for ' do
     resp = Plivo::XML::Response.new
     speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
     speak.addEmphasis('test', level: 'strong')
     xml = Plivo::XML::PlivoXML.new(resp)

     expect(xml.to_xml).to eql("<?xml version=\"1.0\" encoding=\"utf-8\" ?><Response><Speak voice='Polly.Salli'>Test Call<Emphasis level='strong'>test</Emphasis></Speak></Response>")
   end

   it 'should raise exception if invalid attribute value specified' do
     resp = Plivo::XML::Response.new
     speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
     expect{speak.addEmphasis('test', level: 'invalid')}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'invalid attribute value invalid for level')
   end
 end


  describe 'test for <lang>' do
    it 'should succeed' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      speak.addLang('test', {xmllang: 'fr-FR'})
      xml = Plivo::XML::PlivoXML.new(resp)
      puts xml.to_xml

      expect(xml.to_xml).to eql("<?xml version=\"1.0\" encoding=\"utf-8\" ?><Response><Speak voice='Polly.Salli'>Test Call<Lang xml:lang='fr-FR'>test</Lang></Speak></Response>")
    end

    it 'should raise xml exception if required attribute is not specified' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addLang('test')}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'xmllang attribute is a required attribute for lang')
    end
    it 'should raise exception if invalid attribute value specified' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addLang('test', xmllang: 'invalid')}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'invalid attribute value invalid for xmllang')
    end
  end

  it 'should succeed for <p> element' do
    resp = Plivo::XML::Response.new
    speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
    speak.addP('test')
    xml = Plivo::XML::PlivoXML.new(resp)

    expect(xml.to_xml).to eql("<?xml version=\"1.0\" encoding=\"utf-8\" ?><Response><Speak voice='Polly.Salli'>Test Call<P>test</P></Speak></Response>")
  end

  describe 'test for <phoneme>' do
    it 'should succeed' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      speak.addPhoneme('test', ph: 'pɪˈkɑːn', alphabet: 'ipa')
      xml = Plivo::XML::PlivoXML.new(resp)

      expect(xml.to_xml).to eql("<?xml version=\"1.0\" encoding=\"utf-8\" ?><Response><Speak voice='Polly.Salli'>Test Call<Phoneme alphabet='ipa' ph='pɪˈkɑːn'>test</Phoneme></Speak></Response>")
    end

    it 'should raise xml exception if required attribute is not specified' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addPhoneme('test')}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'ph attribute is required for Phoneme')
    end

    it 'should raise exception if invalid attribute value specified' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addPhoneme('test', {ph: 'pɪˈkɑːn', alphabet: 'invalid'})}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'invalid attribute value invalid for alphabet')
    end
  end

  describe 'test for <prosody>' do
    it 'should succeed' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      speak.addProsody('test', {volume: "-20dB", rate: '20%', pitch: '80%'})
      xml = Plivo::XML::PlivoXML.new(resp)

      expect(xml.to_xml).to eql("<?xml version=\"1.0\" encoding=\"utf-8\" ?><Response><Speak voice='Polly.Salli'>Test Call<Prosody pitch='80%' rate='20%' volume='-20dB'>test</Prosody></Speak></Response>")
    end

    it 'should raise xml exception if required attribute is not specified' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addProsody('test')}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'Specify at least one attribute for Prosody tag')
    end

    it 'should raise exception if invalid attribute value specified for volume attribute' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addProsody('test', {volume: 'invalid'})}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'invalid attribute value invalid for volume')
    end

    it 'should raise exception if invalid attribute value specified for rate attribute' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addProsody('test', {rate: '-20%'})}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'invalid attribute value -20% for rate')
    end

    it 'should raise exception if invalid attribute value specified for pitch attribute' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addProsody('test', {pitch: 'invalid'})}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'invalid attribute value invalid for pitch')
    end
  end

  describe 'test for <sub>' do
    it 'should succeed' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      speak.addSub('test', alias: "new word")
      xml = Plivo::XML::PlivoXML.new(resp)

      expect(xml.to_xml).to eql("<?xml version=\"1.0\" encoding=\"utf-8\" ?><Response><Speak voice='Polly.Salli'>Test Call<Sub alias='new word'>test</Sub></Speak></Response>")
    end

    it 'should raise xml exception if required attribute is not specified' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addSub('test')}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'alias is a required attribute for sub element')
    end
  end



  describe 'test for <say-as>' do
    it 'should succeed' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      speak.addSayAs('test', "interpret-as" => "character")
      xml = Plivo::XML::PlivoXML.new(resp)
      expect(xml.to_xml).to eql("<?xml version=\"1.0\" encoding=\"utf-8\" ?><Response><Speak voice='Polly.Salli'>Test Call<SayAs interpret-as='character'>test</SayAs></Speak></Response>")
    end

    it 'should raise xml exception if required attribute is not specified' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addSayAs('test')}.to raise_error(Plivo::Exceptions::PlivoXMLError, "interpret-as is a required attribute for say-as element")
    end

    it 'should raise exception if invalid attribute value specified for interpret-as attribute' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addSayAs('test', {"interpret-as" => 'invalid'})}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'invalid attribute value invalid for interpret-as')
    end

    it 'should raise exception if invalid attribute value specified for format attribute' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addSayAs('test', {"interpret-as" => 'date', format: 'invalid'})}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'invalid attribute value invalid for format')
    end
  end

  it 'should succeed for <s> element' do
    resp = Plivo::XML::Response.new
    speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
    speak.addS('test')
    xml = Plivo::XML::PlivoXML.new(resp)

    expect(xml.to_xml).to eql("<?xml version=\"1.0\" encoding=\"utf-8\" ?><Response><Speak voice='Polly.Salli'>Test Call<S>test</S></Speak></Response>")

  end

  describe 'test for <w>' do
    it 'should succeed for <w> element' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      speak.addW('test', role: 'amazon:VBD')
      xml = Plivo::XML::PlivoXML.new(resp)

      expect(xml.to_xml).to eql("<?xml version=\"1.0\" encoding=\"utf-8\" ?><Response><Speak voice='Polly.Salli'>Test Call<W role='amazon:VBD'>test</W></Speak></Response>")
    end

    it 'should raise exception if invalid attribute value specified' do
      resp = Plivo::XML::Response.new
      speak = resp.addSpeak('Test Call', voice: 'Polly.Salli')
      expect{speak.addW('test', role: 'invalid')}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'invalid attribute value invalid for role')
    end
  end
end

describe "test for speak element" do
  it "should raise xml exception for: if voice is MAN/WOMAN, SSML is not supported" do
    resp = Plivo::XML::Response.new
    speak = resp.addSpeak('Test Call', voice: 'MAN')
    expect{speak.addP('test')}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'P not nestable in Speak')
  end

  it 'should raise xml exception for: if voice attribute is not specified, SSML is not supported' do
    resp = Plivo::XML::Response.new
    speak = resp.addSpeak('Test Call')
    expect{speak.addP('test')}.to raise_error(Plivo::Exceptions::PlivoXMLError, 'P not nestable in Speak')
  end

  it 'should raise xml exception, if specified engine is not supported' do
    resp = Plivo::XML::Response.new
    expect{resp.addSpeak('Test Call', voice: 'Invalid.Salli')}.to raise_error(Plivo::Exceptions::PlivoXMLError, '<Speak> voice Invalid.Salli is not valid.')
  end

  it 'should raise xml exception, if specified voice is not supported' do
    resp = Plivo::XML::Response.new
    expect{resp.addSpeak('Test Call', voice: 'Polly.Invalid')}.to raise_error(Plivo::Exceptions::PlivoXMLError, '<Speak> voice Polly.Invalid is not valid.')
  end
end
