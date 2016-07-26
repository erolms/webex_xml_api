require 'spec_helper'

describe WebexXmlApi::User::GetUser do
  subject { described_class }

  describe '#initialize' do
    it 'creates attr_accessors and sets variables' do
      gu = subject.new(site_name: 'test', webex_id: '123456')
      expect(gu.webex_id).to eql('123456')
      expect(gu.security_context).to be
    end

    it 'ignores invalid parameters' do
      gu = subject.new(webex_id: 'test', invalid_param: 'test')
      expect(gu.webex_id).to eql('test')
      expect(gu).not_to respond_to(:invalid_param)
    end
  end

  describe '#to_xml' do
    it 'raises a NotEnoughArguments exception if arguments missing' do
      gu = subject.new(site_name: 'test')
      expect { gu.to_xml }.
        to raise_error(WebexXmlApi::NotEnoughArguments, 'User::GetUser')
    end

    it 'returns formatted XML text' do
      expected = file_fixture('user_get_user_request.xml')
      gu = subject.new(site_name: 'test', webex_id: '123456', password: 'test')
      expect(gu.to_xml).to eql(expected)
    end
  end

  describe '#valid?' do
    it 'fails if webex_id is missing' do
      gu = subject.new
      expect(gu.valid?).to be_falsey
    end

    it 'succeeds if all required parameters are set' do
      gu = subject.new(webex_id: 'test')
      expect(gu.valid?).to be_truthy
    end
  end
end
