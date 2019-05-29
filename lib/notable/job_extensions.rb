module Notable
  module JobExtensions
    extend ActiveSupport::Concern

    included do
      around_perform do |job, block|
        # no way to get queued_at time :(
        Notable.track_job(job.class.name, job.job_id, job.queue_name, nil, notable_runtime_threshold) do
          block.call
        end
      end

      def notable_runtime_threshold
        Notable.slow_job_threshold
      end
    end
  end
end
