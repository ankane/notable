require_relative "test_helper"

class RequestTest < ActionDispatch::IntegrationTest
  def setup
    Notable::Request.delete_all
  end

  def test_error
    # get error_url
  end

  def test_not_found
  end

  def test_slow
    get slow_url
    request = Notable::Request.last
    assert_equal "Slow Request", request.note_type
  end

  def test_timeout
  end

  def test_validation
  end

  def test_csrf
  end

  def test_unpermitted_parameters
  end

  def test_blocked_request
  end

  def test_throttled_request
  end

  def test_mask_ips

  end
end
