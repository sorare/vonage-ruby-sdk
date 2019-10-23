# frozen_string_literal: true

module Nexmo
  class Conversations < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    self.request_headers['Accept'] = 'application/json'

    # Create a conversation.
    #
    # @example
    #   response = client.conversations.create(name: 'Example Conversation', display_name: 'Example Display Name')
    #
    # @option params [String] :name
    #   Unique name for a conversation.
    #
    # @option params [String] :display_name
    #   The display name for the conversation.
    #   It does not have to be unique.
    #
    # @option params [String] :image_url
    #   A link to an image for conversations' and users' avatars.
    #
    # @option params [Hash] :properties
    #   - **:custom_data** (Hash) Any custom data that you'd like to attach to the conversation.
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#createConversation
    #
    def create(params)
      request('/v0.1/conversations', params: params, type: Post)
    end

    # List all conversations associated with your application.
    #
    # @example
    #   response = client.conversations.list
    #
    # @option params [Integer] :page_size
    #   Return this amount of records in the response.
    #
    # @option params ['asc', 'desc'] :order
    #   Return the records in ascending or descending order.
    #
    # @option params [String] :cursor
    #   The cursor to start returning results from.
    #
    # @param [Hash, nil] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#replaceConversation
    #
    def list(params = nil)
      request('/v0.1/conversations', params: params)
    end

    # Retrieve a conversation.
    #
    # @example
    #   response = client.conversations.get(id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#retrieveConversation
    #
    def get(id)
      request('/v0.1/conversations/' + id)
    end
  
    # Update a conversation.
    #
    # @example
    #   response = client.conversations.update(id, display_name: 'Updated conversation')
    #
    # @option params [String] :name
    #   Unique name for a conversation
    #
    # @option params [String] :display_name
    #   The display name for the conversation.
    #
    # @option params [String] :image_url
    #   A link to an image for conversations' and users' avatars.
    #
    # @option params [Hash] :properties
    #   - **:custom_data** [Hash] Any custom data that you'd like to attach to the conversation.
    #
    # @param [String] id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#replaceConversation
    #
    def update(id, params)
      request('/v0.1/conversations/' + id, params: params, type: Put)
    end

    # Delete a conversation.
    #
    # @example
    #   response = client.conversations.delete(id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#deleteConversation
    #
    def delete(id)
      request('/v0.1/conversations/' + id, type: Delete)
    end

    # Record a conversation.
    #
    # @example
    #   response = client.conversations.record(id, action: 'start')
    #
    # @option params [String] :action
    #   Recording action. Must be one of `start` or `stop`.
    #
    # @option params [String] :event_url
    #   The webhook endpoint where recording progress events are sent to.
    #
    # @option params [String] :event_method
    #   The HTTP method used to send event information to **:event_url**.
    #
    # @option params [String] :split
    #   Record the sent and received audio in separate channels of a stereo recording.
    #
    # @option params [String] :format
    #   Record the conversation in a specific format.
    #
    # @param [String] id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#recordConversation
    #
    def record(id, params)
      request('/v1/conversations/' + id + '/record', params: params, type: Put)
    end

    # @return [Events]
    #
    def events
      @events ||= Events.new(@config)
    end

    # @return [Members]
    #
    def members
      @members ||= Members.new(@config)
    end

    # @return [Users]
    #
    def users
      @users ||= Users.new(@config)
    end
  end
end
