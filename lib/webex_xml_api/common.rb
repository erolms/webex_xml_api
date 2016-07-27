module WebexXmlApi
  module Common
    # Borrowed from Rails' ActiveSupport
    def underscore(camel_cased_word)
      return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
      word = camel_cased_word.to_s.gsub('::'.freeze, '/'.freeze)
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
      word.tr!('-'.freeze, '_'.freeze)
      word.downcase!
      word
    end

    def xml_service_url(site_name)
      "https://#{site_name}.webex.com/WBXService/XMLService".freeze
    end
  end
end
