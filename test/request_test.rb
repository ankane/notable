require_relative "test_helper"

class RequestTest < ActionDispatch::IntegrationTest
  def setup
    Notable::Request.delete_all
  end

  def test_error
    # get error_url
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
    request = Notable::Request.first
    # TODO fix
  end

  def test_validation
    post users_url
    request = Notable::Request.last
    assert_equal "Validation Errors", request.note_type
    assert_equal "User: Email can't be blank", request.note
  end

  def test_csrf
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
