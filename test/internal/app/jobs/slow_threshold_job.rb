class SlowThresholdJob < ActiveJob::Base
  def perform
    sleep(0.05)
  end

  def notable_slow_job_threshold
    0.01
  end
end
