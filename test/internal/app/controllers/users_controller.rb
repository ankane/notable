class UsersController < ActionController::Base
  def create
    User.create(params.permit(:email))
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
    sleep(1.1)
    head :ok
  end

  def timeout
    sleep(2.1)
    head :ok
  end
end
