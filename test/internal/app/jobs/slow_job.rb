class SlowJob < ActiveJob::Base
  def perform
    sleep(0.3)
  end
end
