# An adapter lets two objects with incompatible interfaces work together
require "stringio"
require "json"
require "ostruct"

# Can only send a message in text form
class HTTPRequest
  attr_reader :message

  def initialize(message)
    @message = message
  end
end

# Can only process a message that is in a Hash form
class Server
  attr_reader :request

  def initialize(request)
    raise TypeError.new("Incompatible type: Request message must be a hash") unless request.message.is_a? Hash
    @request = request.message
  end

  def response
    request
  end
end

# Provides an interface for communication between the two incompatible entities (HTTPRequest and Server)
class HTTPRequestServerAdapter
  attr_reader :request
  def initialize(request)
    @request = request
  end

  def message
    parse(request.message)
  end

  def parse(msg)
    head, body =  msg.split("\n\n")
    start_line, _, headers = head.partition("\n")
    body = JSON.parse(body)
    method, path, _ = start_line.split(" ")
    {
      headers:  parse_headers(headers),
      body: body,
      method: method,
      path: path
    }
  end

  def parse_headers(headers)
    headers.split("\n").each_with_object({}) do |e, obj|
      k, _, v = e.partition(":")
      obj[k] = v.strip
    end
  end
end

msg = <<~MSG
        GET /users HTTP/1.1
        HOST: localhost:3000
        Content-Type: application/json; charset=UTF-8
        Content-Length: 54
        
        {
          "name": "Ezewnwa",
          "age": 24,
          "height": 6
        }
      MSG

request = HTTPRequest.new(msg)

adapted_request = HTTPRequestServerAdapter.new(request)

response = Server.new(adapted_request).response # works
p response

response = Server.new(request).response # TypeError incompatible type