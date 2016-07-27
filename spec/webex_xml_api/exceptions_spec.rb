require 'spec_helper'

describe WebexXmlApi::Error do
  subject { described_class }

  describe '#ancestors' do
    subject { super().ancestors }
    it { is_expected.to include(StandardError) }
  end

  describe 'raises an error' do
    it 'with message' do
      expect { raise WebexXmlApi::Error, 'this message exactly' }
        .to raise_error('this message exactly')
    end
  end

  describe WebexXmlApi::NotEnoughArguments do
    describe '#ancestors' do
      subject { super().ancestors }
      it { is_expected.to include(WebexXmlApi::Error) }
    end

    describe 'raises an error' do
      it 'with message' do
        expect { raise WebexXmlApi::NotEnoughArguments, 'this message exactly' }
          .to raise_error('this message exactly')
      end
    end
  end

  describe WebexXmlApi::RequestFailed do
    describe '#ancestors' do
      subject { super().ancestors }
      it { is_expected.to include(WebexXmlApi::Error) }
    end

    describe 'raises an error' do
      before(:each) do
        @resp = {}
        @resp[:code] = '999'
        @resp[:text] = 'Error text'
      end

      it 'returns a response object and error message' do
        expect { raise WebexXmlApi::RequestFailed.new(@resp), 'this message' }
          .to raise_error { |error|
            expect(error.message).to eql('this message')
            expect(error.response).to eql(@resp)
          }
      end
    end
  end
end
