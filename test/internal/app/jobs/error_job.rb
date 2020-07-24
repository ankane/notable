class ErrorJob < ActiveJob::Base
  def perform
    raise "Test error"
  end
end
