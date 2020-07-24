require_relative "test_helper"

class JobTest < ActiveSupport::TestCase
  def setup
    Notable::Job.delete_all
  end

  def test_error
  end

  def test_slow
    SlowJob.perform_now
    job = Notable::Job.last
    assert_equal "Slow Job", job.note_type
    assert_equal "SlowJob", job.job
  end

  def test_validation
  end

  def test_manual
  end
end
