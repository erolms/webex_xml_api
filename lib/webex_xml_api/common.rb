module WebexXmlApi
  module Common
    # POST request to the WebEx XML Service
    def post_webex_request(site_name, request)
      endpoint = "https://#{site_name}.webex.com/WBXService/XMLService".freeze
      HTTParty.post(endpoint, body: request,
                              headers: { 'Content-Type' => 'application/xml' })
    end

    # Check WebEx Response status and raise Exception if FAILURE
    def check_response_and_return_data(resp)
      status = resp.parsed_response['message']['header']['response']['result']
      return resp.parsed_response['message']['body']['bodyContent'] if
        status == 'SUCCESS'
      c = resp.parsed_response['message']['header']['response']['exceptionID']
      t = resp.parsed_response['message']['header']['response']['reason']
      raise WebexXmlApi::RequestFailed.new(resp), "Error #{c}: #{t}"
    end

    # Create WebEx XML Request
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

    def process_object(label, obj, xml, req_type)
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
