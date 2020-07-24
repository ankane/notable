class SlowJob < ActiveJob::Base
  def perform
    sleep(1.1)
  end
end
