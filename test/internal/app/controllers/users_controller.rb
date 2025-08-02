class UsersController < ActionController::Base
  protect_from_forgery with: :null_session

  skip_before_action :track_unverified_request, only: [:update]

  if Rails::VERSION::STRING.to_f >= 7.2
    rate_limit to: 0, within: 1.minute, only: :throttled
  end

  def create
    User.create(params.permit(:email))
    head :ok
  end

  def update
    head :ok
  end

  def error
    raise "Test error"
  end

  def manual
    Notable.track("Test Note", "Test 123")
    head :ok
  end

  def slow
    sleep(0.3)
    head :ok
  end

  def timeout
    sleep(1.1)
    head :ok
  end

  def throttled
    head :ok
  end

  def current_user
    @current_user ||= User.create!(email: "current-user@example.com")
  end
end
