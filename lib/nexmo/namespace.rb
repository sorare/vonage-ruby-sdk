require 'net/http'
require 'json'

module Nexmo
  class Namespace
    def initialize(client)
      @client = client
    end

    private

    Get = Net::HTTP::Get
    Put = Net::HTTP::Put
    Post = Net::HTTP::Post
    Delete = Net::HTTP::Delete

    def host
      'api.nexmo.com'
    end

    def authorization_header?
      false
    end

    def json_body?
      false
    end

    def logger
      @client.logger
    end

    def request(path, params: nil, type: Get, &block)
      uri = URI('https://' + host + path)

      unless authorization_header?
        params ||= {}
        params[:api_key] = @client.api_key
        params[:api_secret] = @client.api_secret
      end

      unless type::REQUEST_HAS_BODY || params.nil? || params.empty?
        uri.query = Params.encode(params)
      end

      message = type.new(uri.request_uri)

      if type::REQUEST_HAS_BODY
        if json_body?
          message['Content-Type'] = 'application/json'
          message.body = JSON.generate(params)
        else
          message.form_data = params
        end
      end

      message['Authorization'] = @client.authorization if authorization_header?
      message['User-Agent'] = @client.user_agent

      http = Net::HTTP.new(uri.host, Net::HTTP.https_default_port)
      http.use_ssl = true

      logger.info('Nexmo API request', method: message.method, path: uri.path)

      response = http.request(message)

      parse(response, &block)
    end

    def parse(response, &block)
      logger.info('Nexmo API response',
        host: host,
        status: response.code,
        type: response.content_type,
        length: response.content_length,
        trace_id: response['x-nexmo-trace-id'])

      case response
      when Net::HTTPNoContent
        :no_content
      when Net::HTTPSuccess
        parse_success(response, &block)
      when Net::HTTPUnauthorized
        raise AuthenticationError, "#{response.code} response from #{host}"
      when Net::HTTPClientError
        raise ClientError, "#{response.code} response from #{host}"
      when Net::HTTPServerError
        raise ServerError, "#{response.code} response from #{host}"
      else
        raise Error, "#{response.code} response from #{host}"
      end
    end

    def parse_success(response)
      if response['Content-Type'].split(';').first == 'application/json'
        JSON.parse(response.body, object_class: Nexmo::Entity)
      elsif block_given?
        yield response
      else
        response.body
      end
    end
  end
end
