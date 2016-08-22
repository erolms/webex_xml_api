module WebexXmlApi
  ##
  # The +Common+ module is a collection of methods used by many other modules
  # and it is being included within those.
  #
  module Common
    ##
    # The +post_webex_request+ method sends the request to WebEx XML Service.
    #
    def post_webex_request(site_name, request)
      endpoint = "https://#{site_name}.webex.com/WBXService/XMLService".freeze
      HTTParty.post(endpoint, body: request,
                              headers: { 'Content-Type' => 'application/xml' })
    end

    ##
    # The +check_response_and_return_data+ method checks the WebEx Response
    # status and raises <tt>WebexXmlApi::RequestFailed</tt> Exception if status
    # is otherwise than SUCCESS. If the request was successful than the parsed
    # Response Hash is returned.
    #
    def check_response_and_return_data(resp)
      status = resp.parsed_response['message']['header']['response']['result']
      return resp.parsed_response['message']['body']['bodyContent'] if
        status == 'SUCCESS'
      c = resp.parsed_response['message']['header']['response']['exceptionID']
      t = resp.parsed_response['message']['header']['response']['reason']
      raise WebexXmlApi::RequestFailed.new(resp), "Error #{c}: #{t}"
    end

    ##
    # The +create_xml_request+ method creates a XML formatted document as
    # understood by WebEx XML API Service including the Security Context.
    #
    def create_xml_request(sec_context, req_type, body_content)
      namespaces = {
        'xmlns:serv' => 'http://www.webex.com/schemas/2002/06/service',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation' => 'http://www.webex.com/schemas/2002/06/service'
      }.freeze
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.message(namespaces) do
          xml.<< sec_context
          xml.body do
            process_object('bodyContent', body_content, xml, req_type)
          end
        end
      end
      builder.doc.root.name = 'serv:message'
      builder.to_xml.gsub(%r{(<\w+\/>)}, '')
    end

    def process_object(label, obj, xml, req_type) # :nodoc:
      xml.send(label) do
        xml.parent['xsi:type'] = req_type if label == 'bodyContent'
        obj.each do |key, value|
          if value.is_a?(Array) || value.is_a?(Hash)
            process_object(key, value, xml, req_type)
          else
            xml.send(key, value) unless value.nil?
          end
        end
      end
    end
  end
end
