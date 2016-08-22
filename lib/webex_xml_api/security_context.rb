module WebexXmlApi
  ##
  # SecurityContext class is shared among other API calls and is providing
  # the WebEx XML API Service with user credentials for authentification.
  #
  class SecurityContext
    # Allowed parameters in the SecurityContext class.
    PARAMETER_MAPPING = {
      webex_id: 'webExID',
      password: 'password',
      site_id: 'siteID',
      site_name: 'siteName',
      partner_id: 'partnerID',
      email: 'email',
      session_ticket: 'sessionTicket',
      client_id: 'clientID',
      client_secret: 'clientSecret'
    }.freeze

    PARAMETER_MAPPING.each_key { |k| attr_accessor k }

    ##
    # The +initialize+ method for newly created instance parsing provided
    # parameters (if any).
    #
    def initialize(attributes = {})
      attributes.each_pair do |k, v|
        send("#{k}=", v) if PARAMETER_MAPPING.key?(k)
      end
    end

    ##
    # The +to_xml+ method returns XML representation of the
    # <tt>SecurityContext</tt> instance as understood by the WebEx XML Service.
    #
    def to_xml
      raise WebexXmlApi::NotEnoughArguments, 'SecurityContext' unless valid?
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.header do
          xml.securityContext do
            PARAMETER_MAPPING.each_pair do |k, v|
              xml.send(v, send(k)) if send(k)
            end
          end
        end
      end
      builder.to_xml.gsub("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n", '')
    end

    ##
    # Returns true if required parameters provided, otherwise false.
    # Parameters :site_name and :webex_id are required.
    # One of the parameters :password or :session_ticket are required too.
    #
    def valid?(context = self)
      return false if context.site_name.nil? || context.webex_id.nil?
      return false if context.password.nil? && context.session_ticket.nil?
      true
    end
  end
end
