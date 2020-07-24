require_relative "test_helper"

class RequestTest < ActionDispatch::IntegrationTest
  def setup
    Notable::Request.delete_all
  end

  def test_error
    # get error_url
  end

  def test_not_found
    # get "/not_found"
    # assert_response :not_found
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
    post validation_url
    request = Notable::Request.last
    assert_equal "Validation Errors", request.note_type
    assert_equal "User: Email can't be blank", request.note
  end

  def test_csrf
  end

  def test_unpermitted_parameters
  end

  def test_blocked_request
  end

  def test_throttled_request
  end

  def test_custom

  end

  def test_mask_ips
    with_mask_ips do
      post validation_url
    end
    request = Notable::Request.last
    assert_equal "127.0.0.0", request.ip
  end

  def test_without_mask_ips
    post validation_url
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
