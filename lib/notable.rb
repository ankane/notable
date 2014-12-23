require "notable/version"

require "request_store"
require "robustly"
require "action_dispatch/middleware/debug_exceptions"

# middleware
require "notable/middleware"
require "notable/engine" if defined?(Rails)

# requests
require "notable/unpermitted_parameters"
require "notable/unverified_request"
require "notable/validation_errors"
require "notable/debug_exceptions"
require "notable/throttle"

# jobs
require "notable/job_backends/sidekiq" if defined?(Sidekiq)
require "notable/job_backends/delayed_job" if defined?(Delayed::Job)

module Notable
  class << self
    attr_accessor :enabled

    # requests
    attr_accessor :track_request_method
    attr_accessor :user_method
    attr_accessor :slow_request_threshold

    # jobs
    attr_accessor :track_job_method
    attr_accessor :slow_job_threshold
  end
  self.enabled = true

  # requests
  self.track_request_method = proc{|data, env| Notable::Request.create!(data) }
  self.user_method = proc{|env| env["warden"].user if env["warden"] }
  self.slow_request_threshold = 5

  # jobs
  self.track_job_method = proc{|data| Notable::Job.create!(data) }
  self.slow_job_threshold = 60

  def self.track(note_type, note = nil)
    (RequestStore.store[:notable_notes] ||= []) << {note_type: note_type, note: note}
  end

  def self.track_error(e)
    track "Error", "#{e.class.name}: #{e.message}"
  end

  def self.notes
    RequestStore.store[:notable_notes].to_a
  end

  def self.clear_notes
    RequestStore.store.delete(:notable_notes)
  end

  def self.track_job(job, job_id, queue, created_at, &block)
    if Notable.enabled
      exception = nil
      notes = nil
      start_time = Time.now
      queued_time = start_time - created_at
      begin
        yield
      rescue Exception => e
        exception = e
      ensure
        notes = Notable.notes
        Notable.clear_notes
      end
      runtime = Time.now - start_time

      safely do
        notes << {note_type: "Error", note: "#{exception.class.name}: #{exception.message}"} if exception
        notes << {note_type: "Slow Job"} if runtime > Notable.slow_job_threshold

        notes.each do |note|
          data = {
            note_type: note[:note_type],
            note: note[:note],
            job: job,
            job_id: job_id,
            queue: queue,
            runtime: runtime,
            queued_time: queued_time
          }

          Notable.track_job_method.call(data)
        end
      end

      raise exception if exception
    else
      yield
    end
  end

end

ActionDispatch::DebugExceptions.send(:include, Notable::DebugExceptions)
