require_relative "test_helper"

class RequestTest < ActionDispatch::IntegrationTest
  def setup
    Notable::Request.delete_all
  end

  def test_error
    get error_url
    request = Notable::Request.last
    assert_equal "Error", request.note_type
    assert_equal "RuntimeError: Test error", request.note
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
    assert_equal "Timeout", request.note_type
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

  def test_csrf_skip_before_action
    with_forgery_protection do
      patch user_url(1)
    end
    assert_equal 0, Notable::Request.count
  end

  def test_unpermitted_parameters
    post users_url, params: {email: "test@example.com", bad: "hello", other: "world"}
    request = Notable::Request.last
    assert_equal "Unpermitted Parameters", request.note_type
    assert_equal "bad, other", request.note
  end

  def test_throttled
    skip if Rails::VERSION::STRING.to_f < 7.2

    get "/throttled"
    request = Notable::Request.last
    # TODO make consistent with rack-attack in 0.7.0
    # assert_equal "Throttle", request.note_type
    # assert_equal "throttle note", request.note
    assert_equal "Too Many Requests", request.note_type
    assert_nil request.note
  end

  def test_rack_blocked
    get "/rack/blocked"
    request = Notable::Request.last
    assert_equal "Throttle", request.note_type
    assert_equal "block note", request.note
  end

  def test_rack_throttled
    get "/rack/throttled"
    request = Notable::Request.last
    assert_equal "Throttle", request.note_type
    assert_equal "throttle note", request.note
  end

  def test_manual
    get manual_url
    request = Notable::Request.last
    assert_equal "Test Note", request.note_type
    assert_equal "Test 123", request.note
  end

  def test_attributes
    get manual_url, params: {hello: "world"}, headers: {"User-Agent" => "TestBot", "Referer" => "http://www.example.com"}
    request = Notable::Request.last
    assert_equal "users#manual", request.action
    assert_equal 200, request.status
    assert_equal "http://www.example.com/manual?hello=world", request.url
    assert_equal "current-user@example.com", request.user.email
    assert request.request_id
    assert "127.0.0.1", request.ip
    assert_equal "TestBot", request.user_agent
    assert_equal "http://www.example.com", request.referrer
    assert_equal({"hello" => "world"}, request.params)
    assert_operator request.request_time, :>, 0
  end

  def test_filtered_parameters
    get manual_url, params: {password: "secret"}
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

  def test_api
    get api_url
    assert_response :success
  end

  def test_track_request_method
    previous_value = Notable.track_request_method
    begin
      data = nil
      env = nil
      Notable.track_request_method = lambda do |d, e|
        data = d
        env = e
      end
      get manual_url
      assert_equal "Test Note", data[:note_type]
      assert env["REQUEST_URI"]
    ensure
      Notable.track_request_method = previous_value
    end
  end

  def with_forgery_protection
    previous_value = ActionController::Base.allow_forgery_protection
    begin
      ActionController::Base.allow_forgery_protection = true
      yield
    ensure
      ActionController::Base.allow_forgery_protection = previous_value
    end
  end

  def with_mask_ips
    Notable.stub(:mask_ips, true) do
      yield
    end
  end
end
