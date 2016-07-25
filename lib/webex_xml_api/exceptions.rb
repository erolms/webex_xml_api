module WebexXmlApi
  # @abstact Exceptions raised by WebexXmlApi inherit from Error
  class Error < StandardError; end

  # Exception raised if you do not provide enough arguments for the Request
  # Object to be valid
  class NotEnoughArguments < Error; end

  # @abstract Exception raised if request against WebEx Service failed
  class RequestFailed < Error
    # Returns the error received by WebEx XML API Service
    # @return [Hash] An object with error code and message
    attr_reader :response

    # Instantiate an instance of RequestFailed with error Object
    # @param [Object] An object with response received by WebEx Service
    def initialize(response)
      @response ||= response
    end
  end
end
