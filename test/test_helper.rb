require "bundler/setup"
require "combustion"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

logger = ActiveSupport::Logger.new(ENV["VERBOSE"] ? STDOUT : nil)

Combustion.path = "test/internal"
Combustion.initialize! :active_record, :action_controller, :active_job do
  if ActiveRecord::VERSION::MAJOR < 6 && config.active_record.sqlite3.respond_to?(:represent_boolean_as_integer)
    config.active_record.sqlite3.represent_boolean_as_integer = true
  end

  config.action_controller.logger = logger
  config.active_record.logger = logger
  config.active_job.logger = logger

  config.active_job.queue_adapter = :inline

  config.action_dispatch.show_exceptions = true
  config.consider_all_requests_local = false

  config.filter_parameters += [:password]

  config.slowpoke.timeout = 1
end

Rack::Attack.blocklist("block note") do |request|
  request.path.start_with?("/blocked")
end

Rack::Attack.throttle("throttle note", limit: 0, period: 1) do |request|
  request.path.start_with?("/throttled")
end

Rack::Timeout::Logger.logger = logger

Notable.slow_job_threshold = 0.2
Notable.slow_request_threshold = 0.2

Notable.user_method = lambda do |env|
  env["action_controller.instance"].try(:current_user)
end
