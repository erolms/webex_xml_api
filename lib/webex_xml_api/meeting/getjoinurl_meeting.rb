module WebexXmlApi
  module Meeting
    class GetjoinurlMeeting
      include WebexXmlApi::Common

      REQUEST_TYPE =
        'java:com.webex.service.binding.meeting.GetjoinurlMeeting'.freeze
      PARAMETER_MAPPING = {
        session_key: 'sessionKey'
      }.freeze

      attr_accessor :session_key, :security_context
      attr_reader :request, :response

      def initialize(attributes = {})
        attributes.each_pair do |k, v|
          send("#{k}=", v) if PARAMETER_MAPPING.key?(k)
        end
        @security_context ||= WebexXmlApi::SecurityContext.new(attributes)
      end

      def to_xml
        raise WebexXmlApi::NotEnoughArguments,
              'Meeting::GetjoinurlMeeting' unless valid?
        body_content = {}
        PARAMETER_MAPPING.each_pair do |k, v|
          body_content[v] = send(k) if send(k)
        end
        create_xml_request(@security_context.to_xml, REQUEST_TYPE,
                           body_content)
      end

      def valid?(context = self)
        return false if context.session_key.nil?
        true
      end

      def send_request
        @request = to_xml
        @response = post_webex_request(security_context.site_name, @request)
        check_response_and_return_data(@response)
      end
    end
  end
end
