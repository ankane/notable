class ManualJob < ActiveJob::Base
  def perform
    Notable.track("Test Note", "Test 123")
  end
end
