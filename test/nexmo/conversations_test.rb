require_relative './test'

class NexmoConversationsTest < Nexmo::Test
  def conversations
    Nexmo::Conversations.new(config)
  end

  def conversations_uri
    'https://api.nexmo.com/v0.1/conversations'
  end

  def conversation_uri
    'https://api.nexmo.com/v0.1/conversations/' + conversation_id
  end

  def conversation_record_uri
    'https://api.nexmo.com/v1/conversations/' + conversation_id + '/record'
  end

  def test_create_method
    params = {
      name: 'test_conversation',
      display_name: 'display_test_name'
    }

    stub_request(:post, conversations_uri).with(request(body: params)).to_return(response)

    assert_kind_of Nexmo::Response, conversations.create(params)
  end

  def test_create_method_with_error
    params = {
      display_name: 123
    }
    
    #stub_request(:post, conversations_uri).with(request(body: params)).to_return(response)
    
    # expect conversations.create(params) to return an error, but currently returning a 200
  end

  def test_list_method
    params = {order: 'asc'}

    stub_request(:get, conversations_uri).with(request(query: params)).to_return(response)

    assert_kind_of Nexmo::Response, conversations.list(params)
  end

  def test_get_method
    stub_request(:get, conversation_uri).with(request).to_return(response)

    assert_kind_of Nexmo::Response, conversations.get(conversation_id)
  end

  def test_update_method
    params = {
      name: 'test_conversation',
      display_name: 'display_test_name'
    }

    stub_request(:put, conversation_uri).with(request(headers: {'Accept' => 'application/json'}, body: params)).to_return(response)

    assert_kind_of Nexmo::Response, conversations.update(conversation_id, params)
  end

  def test_delete_method
    stub_request(:delete, conversation_uri).with(request).to_return(response)

    assert_kind_of Nexmo::Response, conversations.delete(conversation_id)
  end

  def test_record_method
    params = {
      action: 'start',
      format: 'wav'
    }

    stub_request(:put, conversation_record_uri).with(request(body: params)).to_return(response)

    assert_kind_of Nexmo::Response, conversations.record(conversation_id, params)
  end

  def test_events_method
    assert_kind_of Nexmo::Conversations::Events, conversations.events
  end

  def test_members_method
    assert_kind_of Nexmo::Conversations::Members, conversations.members
  end

  def test_users_method
    assert_kind_of Nexmo::Conversations::Users, conversations.users
  end
end
