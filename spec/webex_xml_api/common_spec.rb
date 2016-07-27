require 'spec_helper'

describe WebexXmlApi::Common do
  describe 'methods included in Module' do
    let(:class_with_inclusion) { Class.new.include(described_class) }
  end
end
