class HomeController < ActionController::Base
  def error
    raise "Test error"
  end

  def slow
    sleep(1.1)
    head :ok
  end
end
