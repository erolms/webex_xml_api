require 'spec_helper'

describe WebexXmlApi::Meeting::GetjoinurlMeeting do
  subject { described_class }

  describe '#initialize' do
    it 'creates attr_accessors and sets variables' do
      gjum = subject.new(site_name: 'test', session_key: '123456789')
      expect(gjum.session_key).to eql('123456789')
      expect(gjum.security_context).to be
    end

    it 'ignores invalid parameters' do
      gjum = subject.new(session_key: '123456789', invalid_param: 'test')
      expect(gjum.session_key).to eql('123456789')
      expect(gjum).not_to respond_to(:invalid_param)
    end
  end

  describe '#to_xml' do
    it 'raises a NotEnoughArguments exception if arguments missing' do
      gjum = subject.new(site_name: 'test')
      expect { gjum.to_xml }
        .to raise_error(WebexXmlApi::NotEnoughArguments,
                        'Meeting::GetjoinurlMeeting')
    end

    it 'returns formatted XML text' do
      expected = file_fixture('meeting_getjoinurl_meeting_request.xml')
      gjum = subject.new(site_name: 'test', webex_id: '123456',
                         password: 'test', session_key: '123456789')
      expect(gjum.to_xml).to eql(expected)
    end
  end

  describe '#valid?' do
    it 'fails if session_key is missing' do
      gjum = subject.new
      expect(gjum.valid?).to be_falsey
    end

    it 'succeeds if all required parameters are set' do
      gjum = subject.new(session_key: '123456789')
      expect(gjum.valid?).to be_truthy
    end
  end

  describe '#send_request' do
    it 'raises a NotEnoughArguments exception for GetjoinurlMeeting' do
      gjum = subject.new(site_name: 'test')
      expect { gjum.send_request }
        .to raise_error(WebexXmlApi::NotEnoughArguments,
                        'Meeting::GetjoinurlMeeting')
    end

    it 'raises a NotEnoughArguments exception for SecurityContext' do
      gjum = subject.new(site_name: 'test', session_key: '123456789')
      expect { gjum.send_request }
        .to raise_error(WebexXmlApi::NotEnoughArguments, 'SecurityContext')
    end

    it 'raises a RequestFailed exception with error message' do
      gjum = subject.new(site_name: 'test', webex_id: 'test', password: 'test',
                         session_key: '987654321')
      bad_reply = file_fixture('meeting_getjoinurl_meeting_response_bad.xml')
      stub_request(:post, 'https://test.webex.com/WBXService/XMLService')
        .to_return(bad_reply)
      expect { gjum.send_request }
        .to raise_error { |error|
          expect(error.message)
            .to eql('Error 060001: Corresponding Meeting not found')
        }
    end

    it 'returns Response bodyContent as hash' do
      gjum = subject.new(site_name: 'test', webex_id: 'test', password: 'test',
                         session_key: '123456789')
      good_reply = file_fixture('meeting_getjoinurl_meeting_response_good.xml')
      stub_request(:post, 'https://test.webex.com/WBXService/XMLService')
        .to_return(good_reply)
      ret = gjum.send_request
      expect(ret).to be
      expect(ret.key?('joinMeetingURL')).to be_truthy
      expect(ret.key?('inviteMeetingURL')).to be_truthy
    end
  end
end
