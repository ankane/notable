module Notable
  module JobBackends
    class Sidekiq
      WRAPPER_CLASSES = Set.new(["ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper"])

      def call(worker, job, queue)
        name =
          if WRAPPER_CLASSES.include?(job["class"])
            job["args"].first["job_class"]
          else
            job["class"]
          end

        Notable.track_job name, job["jid"], queue, Time.at(job["enqueued_at"]) do
          yield
        end
      end
    end
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Notable::JobBackends::Sidekiq
  end
end
