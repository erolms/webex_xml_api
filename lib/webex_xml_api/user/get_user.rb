require 'nokogiri'

module WebexXmlApi
  module User
    class GetUser
      include WebexXmlApi::Common

      REQUEST_TYPE = 'java:com.webex.service.binding.user.GetUser'.freeze
      PARAMETER_MAPPING = {
        webex_id: 'webExId'
      }.freeze

      attr_accessor :webex_id, :security_context
      attr_reader :request, :response

      def initialize(attributes = {})
        attributes.each_pair do |k, v|
          send("#{k}=", v) if PARAMETER_MAPPING.key?(k)
        end
        @security_context ||= WebexXmlApi::SecurityContext.new(attributes)
      end

      def to_xml
        raise WebexXmlApi::NotEnoughArguments, 'User::GetUser' unless valid?
        builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
          xml.message('xmlns:serv' => 'http://www.webex.com/schemas/2002/06/service',
                      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                      'xsi:schemaLocation' =>
                        'http://www.webex.com/schemas/2002/06/service') do
            xml.<< @security_context.to_xml
            xml.body do
              xml.bodyContent('xsi:type' => REQUEST_TYPE) do
                PARAMETER_MAPPING.each_pair do |k, v|
                  xml.send(v, send(k.to_s)) if send(k.to_s)
                end
              end
            end
          end
        end
        builder.to_xml
      end

      def valid?(context = self)
        return false if context.webex_id.nil?
        true
      end

      def send_request
        raise WebexXmlApi::NotEnoughArguments, 'User::GetUser' unless valid?
        raise WebexXmlApi::NotEnoughArguments,
              'SecurityContext' unless security_context.valid?
        @request = to_xml
        @response = HTTParty.post(xml_service_url(security_context.site_name),
                                  body: @request,
                                  headers: {
                                    'Content-Type' => 'application/xml'
                                  })
        resp_status, err_code, err_text = check_response_code(@response)
        raise WebexXmlApi::RequestFailed.new(@response),
              "Error #{err_code}: #{err_text}" if resp_status == 'FAILURE'
        @response.parsed_response['message']['body']['bodyContent']
      end

      private

      def check_response_code(resp)
        status = resp.parsed_response['message']['header']['response']['result']
        return status, nil, nil if status == 'SUCCESS'
        c = resp.parsed_response['message']['header']['response']['exceptionID']
        t = resp.parsed_response['message']['header']['response']['reason']
        # rubocop:disable RedundantReturn
        return status, c, t
        # rubocop:enable RedundantReturn
      end
    end
  end
end
