module Notable
  module JobExtensions
    extend ActiveSupport::Concern

    included do
      around_perform do |job, block|
        # no way to get queued_at time :(
        Notable.track_job(job.class.name, job.job_id, job.queue_name, nil) do
          block.call
        end
      end
    end
  end
end
