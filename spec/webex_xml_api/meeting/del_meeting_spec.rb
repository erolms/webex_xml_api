require 'spec_helper'

describe WebexXmlApi::Meeting::DelMeeting do
  subject { described_class }

  describe '#initialize' do
    it 'creates attr_accessors and sets variables' do
      dm = subject.new(site_name: 'test', meeting_key: '123456789')
      expect(dm.meeting_key).to eql('123456789')
      expect(dm.security_context).to be
    end

    it 'ignores invalid parameters' do
      dm = subject.new(meeting_key: '123456789', invalid_param: 'test')
      expect(dm.meeting_key).to eql('123456789')
      expect(dm).not_to respond_to(:invalid_param)
    end
  end

  describe '#to_xml' do
    it 'raises a NotEnoughArguments exception if arguments missing' do
      dm = subject.new(site_name: 'test')
      expect { dm.to_xml }
        .to raise_error(WebexXmlApi::NotEnoughArguments, 'Meeting::DelMeeting')
    end

    it 'returns formatted XML text' do
      expected = file_fixture('meeting_del_meeting_request.xml')
      dm = subject.new(site_name: 'test', webex_id: '123456', password: 'test',
                       meeting_key: '123456789')
      expect(dm.to_xml).to eql(expected)
    end
  end

  describe '#valid?' do
    it 'fails if meeting_key is missing' do
      dm = subject.new
      expect(dm.valid?).to be_falsey
    end

    it 'succeeds if all required parameters are set' do
      dm = subject.new(meeting_key: '123456789')
      expect(dm.valid?).to be_truthy
    end
  end

  describe '#send_request' do
    it 'raises a NotEnoughArguments exception for DelMeeting' do
      dm = subject.new(site_name: 'test')
      expect { dm.send_request }
        .to raise_error(WebexXmlApi::NotEnoughArguments, 'Meeting::DelMeeting')
    end

    it 'raises a NotEnoughArguments exception for SecurityContext' do
      dm = subject.new(site_name: 'test', meeting_key: '123456789')
      expect { dm.send_request }
        .to raise_error(WebexXmlApi::NotEnoughArguments, 'SecurityContext')
    end

    it 'raises a RequestFailed exception with error message' do
      dm = subject.new(site_name: 'test', webex_id: 'test', password: 'test',
                       meeting_key: '987654321')
      bad_reply = file_fixture('meeting_del_meeting_response_bad.xml')
      stub_request(:post, 'https://test.webex.com/WBXService/XMLService')
        .to_return(bad_reply)
      expect { dm.send_request }
        .to raise_error { |error|
          expect(error.message)
            .to eql('Error 060001: Corresponding Meeting not found')
        }
    end

    it 'returns Response bodyContent as hash' do
      dm = subject.new(site_name: 'test', webex_id: 'test', password: 'test',
                       meeting_key: '123456789')
      good_reply = file_fixture('meeting_del_meeting_response_good.xml')
      stub_request(:post, 'https://test.webex.com/WBXService/XMLService')
        .to_return(good_reply)
      ret = dm.send_request
      expect(ret).to be
      expect(ret.key?('iCalendarURL')).to be_truthy
      expect(ret['iCalendarURL'].key?('host')).to be_truthy
    end
  end
end
