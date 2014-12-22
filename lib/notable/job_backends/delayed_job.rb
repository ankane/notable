module Notable
  module JobBackends
    class DelayedJob < Delayed::Plugin
      callbacks do |lifecycle|
        lifecycle.around(:invoke_job) do |job, *args, &block|
          Notable.track_job job.name, job.id, job.queue, job.created_at do
            block.call(job, *args)
          end
        end
      end
    end
  end
end

Delayed::Worker.plugins << Notable::JobBackends::DelayedJob
