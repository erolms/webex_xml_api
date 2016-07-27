require 'spec_helper'

describe WebexXmlApi::Meeting::GetMeeting do
  subject { described_class }

  describe '#initialize' do
    it 'creates attr_accessors and sets variables' do
      gm = subject.new(site_name: 'test', meeting_key: '123456789')
      expect(gm.meeting_key).to eql('123456789')
      expect(gm.security_context).to be
    end

    it 'ignores invalid parameters' do
      gm = subject.new(meeting_key: '123456789', invalid_param: 'test')
      expect(gm.meeting_key).to eql('123456789')
      expect(gm).not_to respond_to(:invalid_param)
    end
  end

  describe '#to_xml' do
    it 'raises a NotEnoughArguments exception if arguments missing' do
      gm = subject.new(site_name: 'test')
      expect { gm.to_xml }
        .to raise_error(WebexXmlApi::NotEnoughArguments, 'Meeting::GetMeeting')
    end

    it 'returns formatted XML text' do
      expected = file_fixture('meeting_get_meeting_request.xml')
      gm = subject.new(site_name: 'test', webex_id: '123456', password: 'test',
                       meeting_key: '123456789')
      expect(gm.to_xml).to eql(expected)
    end
  end

  describe '#valid?' do
    it 'fails if meeting_key is missing' do
      gm = subject.new
      expect(gm.valid?).to be_falsey
    end

    it 'succeeds if all required parameters are set' do
      gm = subject.new(meeting_key: '123456789')
      expect(gm.valid?).to be_truthy
    end
  end

  describe '#send_request' do
    it 'raises a NotEnoughArguments exception for GetMeeting' do
      gm = subject.new(site_name: 'test')
      expect { gm.send_request }
        .to raise_error(WebexXmlApi::NotEnoughArguments, 'Meeting::GetMeeting')
    end

    it 'raises a NotEnoughArguments exception for SecurityContext' do
      gm = subject.new(site_name: 'test', meeting_key: '123456789')
      expect { gm.send_request }
        .to raise_error(WebexXmlApi::NotEnoughArguments, 'SecurityContext')
    end

    it 'raises a RequestFailed exception with error message' do
      gm = subject.new(site_name: 'test', webex_id: 'test', password: 'test',
                       meeting_key: '987654321')
      bad_reply = file_fixture('meeting_get_meeting_response_bad.xml')
      stub_request(:post, 'https://test.webex.com/WBXService/XMLService')
        .to_return(bad_reply)
      expect { gm.send_request }
        .to raise_error { |error|
          expect(error.message)
            .to eql('Error 060001: Corresponding Meeting not found')
        }
    end

    it 'returns Response bodyContent as hash' do
      gm = subject.new(site_name: 'test', webex_id: 'test', password: 'test',
                       meeting_key: '123456789')
      good_reply = file_fixture('meeting_get_meeting_response_good.xml')
      stub_request(:post, 'https://test.webex.com/WBXService/XMLService')
        .to_return(good_reply)
      ret = gm.send_request
      expect(ret).to be
      expect(ret.key?('meetingkey')).to be_truthy
      expect(ret['hostKey']).to eql('123456')
    end
  end
end
