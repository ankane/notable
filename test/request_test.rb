require_relative "test_helper"

class RequestTest < ActionDispatch::IntegrationTest
  def setup
    Notable::Request.delete_all
  end

  def test_error
    get error_url
    request = Notable::Request.last
    assert_equal "Internal Server Error", request.note_type
    # TODO fix
    # assert_equal "RuntimeError: Test error", request.note
    assert_equal 500, request.status
  end

  def test_not_found
    get "/not_found"
    request = Notable::Request.last
    assert_equal "Not Found", request.note_type
    assert_equal 404, request.status
  end

  def test_slow
    get slow_url
    request = Notable::Request.last
    assert_equal "Slow Request", request.note_type
  end

  def test_timeout
    get timeout_url
    request = Notable::Request.last
    # TODO should be Timeout
    assert_equal "Service Unavailable", request.note_type
    assert_equal 503, request.status
  end

  def test_validation
    post users_url
    request = Notable::Request.last
    assert_equal "Validation Errors", request.note_type
    assert_equal "User: Email can't be blank", request.note
  end

  def test_csrf
    with_forgery_protection do
      post users_url
    end
    request = Notable::Request.first
    assert_equal "Unverified Request", request.note_type
    assert_match "nil != ", request.note
  end

  def test_unpermitted_parameters
    post users_url, params: {email: "test@example.org", bad: "hello", other: "world"}
    request = Notable::Request.last
    assert_equal "Unpermitted Parameters", request.note_type
    assert_equal "bad, other", request.note
  end

  def test_blocked
    get "/blocked"
    request = Notable::Request.last
    assert_equal "Throttle", request.note_type
    assert_equal "block note", request.note
  end

  def test_throttled
    get "/throttled"
    request = Notable::Request.last
    assert_equal "Throttle", request.note_type
    assert_equal "throttle note", request.note
  end

  def test_manual
    get manual_path
    request = Notable::Request.last
    assert_equal "Test Note", request.note_type
    assert_equal "Test 123", request.note
  end

  def test_attributes
    get manual_path, params: {hello: "world"}, headers: {"User-Agent" => "TestBot", "Referer" => "http://www.example.com"}
    request = Notable::Request.last
    assert_equal "users#manual", request.action
    assert_equal 200, request.status
    assert_equal "http://www.example.com/manual?hello=world", request.url
    assert request.request_id
    assert "127.0.0.1", request.ip
    assert_equal "TestBot", request.user_agent
    assert_equal "http://www.example.com", request.referrer
    assert_equal({"hello" => "world"}, request.params)
    assert request.request_time
  end

  def test_filtered_parameters
    get manual_path, params: {password: "secret"}
    request = Notable::Request.last
    assert_equal({"password"=>"[FILTERED]"}, request.params)
  end

  def test_mask_ips
    with_mask_ips do
      post users_url
    end
    request = Notable::Request.last
    assert_equal "127.0.0.0", request.ip
  end

  def test_without_mask_ips
    post users_url
    request = Notable::Request.last
    assert_equal "127.0.0.1", request.ip
  end

  def with_forgery_protection
    previous_value = ActionController::Base.allow_forgery_protection
    begin
      ActionController::Base.allow_forgery_protection = true
      yield
    rescue
      ActionController::Base.allow_forgery_protection = previous_value
    end
  end

  def with_mask_ips
    previous_value = Notable.mask_ips
    begin
      Notable.mask_ips = true
      yield
    ensure
      Notable.mask_ips = previous_value
    end
  end
end
