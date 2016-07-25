require 'spec_helper'

describe WebexXmlApi::SecurityContext do
  subject { described_class }

  describe '#initialize' do
    it 'creates attr_accessors and sets variables' do
      sc = subject.new(site_name: 'test', site_id: '123456')
      expect(sc.site_name).to eql('test')
      expect(sc.site_id).to eql('123456')
      expect(sc.email).to be_nil
    end

    it 'ignores invalid parameters' do
      sc = subject.new(site_name: 'test', invalid_param: 'test')
      expect(sc.site_name).to eql('test')
      expect(sc).not_to respond_to(:invalid_param)
    end
  end

  describe '#to_xml' do
    it 'returns formatted XML text' do
      expected = "<header>\n  <securityContext>\n    <siteName>test</siteName>\n  </securityContext>\n</header>\n"
      sc = subject.new(site_name: 'test')
      expect(sc.to_xml).to eql(expected)
    end
  end
end
