module WebexXmlApi
  # Exceptions raised by WebexXmlApi inherit from Error
  class Error < StandardError; end

  # Exception raised if you do not provide enough arguments for the Request
  # Object to be valid.
  class NotEnoughArguments < Error; end

  # Exception raised if request against WebEx Service fails
  # Returns the error received by WebEx XML API Service
  # @return [Hash] An object with error code and message
  class RequestFailed < Error
    # The reader method for the response object
    attr_reader :response

    # Instantiate an instance of +RequestFailed+ with an error Object
    # @param response [Object] object with response received by WebEx Service
    def initialize(response)
      @response ||= response
    end
  end
end
