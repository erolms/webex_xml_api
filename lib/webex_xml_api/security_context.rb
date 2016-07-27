require 'nokogiri'

module WebexXmlApi
  class SecurityContext
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

    def initialize(attributes = {})
      attributes.each_pair do |k, v|
        send("#{k}=", v) if PARAMETER_MAPPING.key?(k)
      end
    end

    def to_xml
      raise WebexXmlApi::NotEnoughArguments, 'SecurityContext' unless valid?
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.header do
          xml.securityContext do
            PARAMETER_MAPPING.each_pair do |k, v|
              xml.send(v, send(k.to_s)) if send(k.to_s)
            end
          end
        end
      end
      builder.to_xml.gsub("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n", '')
    end

    def valid?(context = self)
      return false if context.site_name.nil? || context.webex_id.nil?
      return false if context.password.nil? && context.session_ticket.nil?
      true
    end
  end
end
