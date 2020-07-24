module Notable
  module JobExtensions
    extend ActiveSupport::Concern

    included do
      around_perform do |job, block|
        # enqueued_at is only available in Active Job 6+
        Notable.track_job(job.class.name, job.job_id, job.queue_name, job.try(:enqueued_at), try(:notable_slow_job_threshold)) do
          block.call
        end
      end
    end
  end
end
