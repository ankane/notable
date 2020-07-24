require_relative "test_helper"

class JobTest < ActiveSupport::TestCase
  def setup
    Notable::Job.delete_all
  end

  def test_error
    ErrorJob.perform_now rescue nil
    job = Notable::Job.last
    assert_equal "Error", job.note_type
    assert_equal "RuntimeError: Test error", job.note
  end

  def test_slow
    SlowJob.perform_now
    job = Notable::Job.last
    assert_equal "Slow Job", job.note_type
    assert_equal "SlowJob", job.job
  end

  def test_validation
    ValidationJob.perform_now
    job = Notable::Job.last
    assert_equal "Validation Errors", job.note_type
    assert_equal "User: Email can't be blank", job.note
  end

  def test_manual
    ManualJob.perform_now
    job = Notable::Job.last
    assert_equal "Test Note", job.note_type
    assert_equal "Test 123", job.note
  end
end
