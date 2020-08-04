class UsersController < ActionController::Base
  skip_before_action :track_unverified_request, only: [:update]

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

  def current_user
    @current_user ||= User.create!(email: "current-user@example.com")
  end
end
