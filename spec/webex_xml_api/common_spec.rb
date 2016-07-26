require 'spec_helper'

describe WebexXmlApi::Common do
  describe 'methods included in Module' do
    let(:class_with_inclusion) { Class.new.include(described_class) }

    describe '#underscore' do
      subject { class_with_inclusion.new }

      it 'returns unchanged string' do
        expect(subject.underscore('unchanged')).to eql('unchanged')
      end

      it 'returns string with path' do
        expect(subject.underscore('WebexXmlApi::Common')).
          to eql('webex_xml_api/common')
      end

      it 'returns string with dash changed to underscore' do
        expect(subject.underscore('Webex-Xml-Api')).to eql('webex_xml_api')
      end
    end

    describe '#xml_service_url' do
      subject { class_with_inclusion.new }

      it 'returns WebEx XML Service URL' do
        expect(subject.xml_service_url('testsite')).
          to eql('https://testsite.webex.com/WBXService/XMLService')
      end
    end
  end
end
