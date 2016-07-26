require 'nokogiri'

module WebexXmlApi
  module User
    class GetUser
      include WebexXmlApi::Common

      REQUEST_TYPE = 'java:com.webex.service.binding.user.GetUser'.freeze
      PARAMETER_MAPPING = {
        :webex_id => 'webExID'
      }

      attr_accessor :webex_id, :security_context
      attr_reader :request, :response

      def initialize(attributes = {})
        attributes.each_pair do |k, v|
          send("#{k}=", v) if PARAMETER_MAPPING.has_key?(k)
        end
        @security_context ||= WebexXmlApi::SecurityContext.new(attributes)
      end

      def to_xml
        raise WebexXmlApi::NotEnoughArguments, 'User::GetUser' unless valid?
        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
          xml.message('xmlns:serv' => 'http://www.webex.com/schemas/2002/06/service',
                      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                      'xsi:schemaLocation' => 'http://www.webex.com/schemas/2002/06/service') do
            xml.<< @security_context.to_xml
            xml.body do
              xml.bodyContent('xsi:type' => REQUEST_TYPE) do
                PARAMETER_MAPPING.each_pair do |k, v|
                  xml.send(v, send("#{k}")) if send("#{k}")
                end
              end
            end
          end
        end
        builder.doc.to_xml
      end

      def valid?(context = self)
        return false if context.webex_id.nil?
        true
      end
    end
  end
end
