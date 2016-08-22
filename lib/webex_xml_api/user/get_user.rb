module WebexXmlApi
  ##
  # The +User+ module of the API
  #
  module User
    ##
    # The +GetUser+ Class queries WebEx API Service for given WebEx User ID
    # and returns the details of the User configuration
    #
    class GetUser
      include WebexXmlApi::Common

      # XML Request Type for the <tt>WebexXmlApi::User::GetUser</tt> service
      REQUEST_TYPE = 'java:com.webex.service.binding.user.GetUser'.freeze

      # The webex_id is required parameter for this service
      PARAMETER_MAPPING = {
        webex_id: 'webExId'
      }.freeze

      # Accessor methods for the webex_id property and security_context object
      attr_accessor :webex_id, :security_context
      # Reader methods for request and response objects
      attr_reader :request, :response

      ##
      # The +initialize+ method for newly created instance parsing provided
      # parameters (if any). The +initialize+ method automaticaly creates
      # new +SecurityContext+ instance and passes the attribes.
      #
      def initialize(attributes = {})
        attributes.each_pair do |k, v|
          send("#{k}=", v) if PARAMETER_MAPPING.key?(k)
        end
        @security_context ||= WebexXmlApi::SecurityContext.new(attributes)
      end

      ##
      # The +to_xml+ method returns XML representation of the
      # <tt>WebexXmlApi::User::GetUser</tt> instance as understood by
      # the WebEx XML Service.
      #
      def to_xml
        raise WebexXmlApi::NotEnoughArguments, 'User::GetUser' unless valid?
        body_content = {}
        PARAMETER_MAPPING.each_pair do |k, v|
          body_content[v] = send(k) if send(k)
        end
        create_xml_request(@security_context.to_xml, REQUEST_TYPE,
                           body_content)
      end

      ##
      # Returns true if required parameters provided, otherwise false.
      #
      def valid?(context = self)
        return false if context.webex_id.nil?
        true
      end

      ##
      # The +send_request+ method will issue the XML API request to WebEx,
      # parse the results and return data if successful. Upon failure an
      # exception is raised.
      #
      def send_request
        @request = to_xml
        @response = post_webex_request(security_context.site_name, @request)
        check_response_and_return_data(@response)
      end
    end
  end
end
