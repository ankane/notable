require_relative "test_helper"

class JobTest < ActiveSupport::TestCase
  def setup
    Notable::Job.delete_all
  end

  def test_error
    ErrorJob.perform_later rescue nil
    job = Notable::Job.last
    assert_equal "Error", job.note_type
    assert_equal "RuntimeError: Test error", job.note
  end

  def test_slow
    SlowJob.perform_later
    job = Notable::Job.last
    assert_equal "Slow Job", job.note_type
  end

  def test_slow_specific_job
    SlowThresholdJob.perform_later
    job = Notable::Job.last
    assert_equal "Slow Job", job.note_type
  end

  def test_validation
    ValidationJob.perform_later
    job = Notable::Job.last
    assert_equal "Validation Errors", job.note_type
    assert_equal "User: Email can't be blank", job.note
  end

  def test_manual
    ManualJob.perform_later
    job = Notable::Job.last
    assert_equal "Test Note", job.note_type
    assert_equal "Test 123", job.note
  end

  def test_attributes
    ManualJob.perform_later
    job = Notable::Job.last
    assert_equal "ManualJob", job.job
    assert job.job_id
    assert_equal "default", job.queue
    assert_operator job.runtime, :>, 0
    assert_operator job.queued_time, :>, 0
  end

  def test_queued_time_perform_now
    ManualJob.perform_now
    job = Notable::Job.last
    assert_nil job.queued_time
  end

  def test_track_job_method
    previous_value = Notable.track_job_method
    begin
      data = nil
      Notable.track_job_method = lambda do |d|
        data = d
      end
      ManualJob.perform_later
      assert_equal "Test Note", data[:note_type]
    ensure
      Notable.track_job_method = previous_value
    end
  end
end
