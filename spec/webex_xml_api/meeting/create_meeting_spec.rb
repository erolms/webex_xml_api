require 'spec_helper'

describe WebexXmlApi::Meeting::CreateMeeting do
  subject { described_class }

  describe '#initialize' do
    it 'creates new security_context' do
      sm = subject.new(site_name: 'test')
      expect(sm.security_context).to be
    end
  end

  describe '#to_xml' do
    it 'raises a NotEnoughArguments exception if arguments missing' do
      sm = subject.new(site_name: 'test')
      expect { sm.to_xml }
        .to raise_error(WebexXmlApi::NotEnoughArguments,
                        'Meeting::CreateMeeting')
    end

    it 'returns formatted XML text' do
      expected = file_fixture('meeting_create_meeting_request.xml')
      sm = subject.new(site_name: 'test', webex_id: '123456', password: 'test')
      sm.conf_name = 'Test-Meeting via XML API'
      sm.start_date = '07/30/2016 15:00:00'
      sm.duration = '60'
      expect(sm.to_xml).to eql(expected)
    end
  end

  describe '#valid?' do
    it 'fails if required fields are missing' do
      sm = subject.new
      expect(sm.valid?).to be_falsey
    end

    it 'succeeds if all required parameters are set' do
      sm = subject.new
      sm.conf_name = 'Test-Meeting via XML API'
      sm.start_date = '07/30/2016 15:00:00'
      sm.duration = '60'
      expect(sm.valid?).to be_truthy
    end
  end

  describe '#send_request' do
    it 'raises a NotEnoughArguments exception for CreateMeeting' do
      sm = subject.new(site_name: 'test')
      expect { sm.send_request }
        .to raise_error(WebexXmlApi::NotEnoughArguments,
                        'Meeting::CreateMeeting')
    end

    it 'raises a NotEnoughArguments exception for SecurityContext' do
      sm = subject.new(site_name: 'test')
      sm.conf_name = 'Test-Meeting via XML API'
      sm.start_date = '07/30/2016 15:00:00'
      sm.duration = '60'
      expect { sm.send_request }
        .to raise_error(WebexXmlApi::NotEnoughArguments, 'SecurityContext')
    end

    it 'raises a RequestFailed exception with error message' do
      sm = subject.new(site_name: 'test', webex_id: 'test', password: 'test')
      sm.conf_name = 'Test-Meeting via XML API'
      sm.start_date = '07/30/2016 15:00:00'
      sm.duration = '60'
      bad_reply = file_fixture('meeting_create_meeting_response_bad.xml')
      stub_request(:post, 'https://test.webex.com/WBXService/XMLService')
        .to_return(bad_reply)
      expect { sm.send_request }
        .to raise_error { |error|
          expect(error.message)
            .to eql('Error 060026: Meeting password must not be null')
        }
    end

    it 'returns Response bodyContent as hash' do
      sm = subject.new(site_name: 'test', webex_id: 'test', password: 'test')
      sm.conf_name = 'Test-Meeting via XML API'
      sm.start_date = '07/30/2016 15:00:00'
      sm.duration = '60'
      good_reply = file_fixture('meeting_create_meeting_response_good.xml')
      stub_request(:post, 'https://test.webex.com/WBXService/XMLService')
        .to_return(good_reply)
      ret = sm.send_request
      expect(ret).to be
      expect(ret.key?('iCalendarURL')).to be_truthy
      expect(ret['meetingkey']).to eql('123456789')
    end
  end

  describe '#getters_and_setters' do
    it 'sets and reads instance variables' do
      sm = subject.new
      expect(sm.conf_name = 'tst').to eql(sm.conf_name)
      expect(sm.agenda = 'tst').to eql(sm.agenda)
      expect(sm.meeting_password = 'tst').to eql(sm.meeting_password)
      expect(sm.start_date = 'tst').to eql(sm.start_date)
      expect(sm.duration = 'tst').to eql(sm.duration)
      expect(sm.open_time = 'tst').to eql(sm.open_time)
      expect(sm.join_teleconf_before_host = 'tst')
        .to eql(sm.join_teleconf_before_host)
      expect(sm.first_attendee_as_presenter = 'tst')
        .to eql(sm.first_attendee_as_presenter)
      expect(sm.telephony_support = 'tst').to eql(sm.telephony_support)
      expect(sm.intl_local_call_in = 'tst').to eql(sm.intl_local_call_in)
      expect(sm.teleconf_location = 'tst').to eql(sm.teleconf_location)
      expect(sm.is_mp_audio = 'tst').to eql(sm.is_mp_audio)
      expect(sm.enable_chat = 'tst').to eql(sm.enable_chat)
      expect(sm.enable_audio_video = 'tst').to eql(sm.enable_audio_video)
    end
  end

  describe '#start_date' do
    it 'converts DateTime to formatted string' do
      sm = subject.new
      expected = '07/29/2016 16:00:00'
      input = DateTime.new(2016, 7, 29, 16, 0, 0)
      sm.start_date = input
      expect(sm.start_date).to eql(expected)
    end

    it 'passes string without conversion' do
      sm = subject.new
      expected = '07/29/2016 16:59:59'
      sm.start_date = expected
      expect(sm.start_date).to eql(expected)
    end
  end
end
