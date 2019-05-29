# dependencies
require "safely/core"

# modules
require "notable/debug_exceptions"
require "notable/middleware"
require "notable/throttle"
require "notable/unpermitted_parameters"
require "notable/version"

require "notable/engine" if defined?(Rails)

module Notable
  class << self
    attr_accessor :enabled
    attr_accessor :requests_enabled
    attr_accessor :jobs_enabled

    # requests
    attr_accessor :track_request_method
    attr_accessor :user_method
    attr_accessor :slow_request_threshold
    attr_accessor :mask_ips

    # jobs
    attr_accessor :track_job_method
    attr_accessor :slow_job_threshold
  end
  self.enabled = true
  self.requests_enabled = true
  self.jobs_enabled = true
  self.mask_ips = false

  def self.requests_enabled?
    enabled && requests_enabled
  end

  def self.jobs_enabled?
    enabled && jobs_enabled
  end

  # requests
  self.track_request_method = -> (data, _) { Notable::Request.create!(data) }
  self.user_method = -> (env) { env["warden"].user if env["warden"] }
  self.slow_request_threshold = 5

  # jobs
  self.track_job_method = -> (data) { Notable::Job.create!(data) }
  self.slow_job_threshold = 60

  def self.track(note_type, note = nil)
    notes << {note_type: note_type, note: note}
  end

  def self.track_error(e)
    track "Error", "#{e.class.name}: #{e.message}"
  end

  def self.notes
    Thread.current[:notable_notes] ||= []
  end

  def self.clear_notes
    Thread.current[:notable_notes] = nil
  end

  def self.track_job(job, job_id, queue, created_at, slow_job_threshold = nil)
    slow_job_threshold ||= Notable.slow_job_threshold
    exception = nil
    notes = nil
    start_time = Time.now
    queued_time = created_at ? start_time - created_at : nil
    begin
      yield
    rescue Exception => e
      exception = e
      track_error(e)
    ensure
      notes = Notable.notes
      Notable.clear_notes
    end
    runtime = Time.now - start_time

    Safely.safely do
      notes << {note_type: "Slow Job"} if runtime > slow_job_threshold

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
  end

  def self.mask_ip(ip)
    addr = IPAddr.new(ip)
    if addr.ipv4?
      # set last octet to 0
      addr.mask(24).to_s
    else
      # set last 80 bits to zeros
      addr.mask(48).to_s
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  require "notable/unverified_request"
  include Notable::UnverifiedRequest
end

ActiveSupport.on_load(:active_record) do
  require "notable/validation_errors"
  include Notable::ValidationErrors
end

ActiveSupport.on_load(:active_job) do
  if Notable.jobs_enabled?
    require "notable/job_extensions"
    include Notable::JobExtensions
  end
end
