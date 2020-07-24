require "bundler/setup"
Bundler.require(:development)
require "minitest/autorun"
require "minitest/pride"

logger = ActiveSupport::Logger.new(ENV["VERBOSE"] ? STDOUT : nil)

Combustion.path = "test/internal"
Combustion.initialize! :active_record, :action_controller, :active_job do
  if ActiveRecord::VERSION::MAJOR < 6 && config.active_record.sqlite3.respond_to?(:represent_boolean_as_integer)
    config.active_record.sqlite3.represent_boolean_as_integer = true
  end

  config.active_job.queue_adapter = :test

  config.action_controller.logger = logger
  config.active_record.logger = logger
  config.active_job.logger = logger

  # need to manually add in test environment
  config.middleware.insert_before Rack::Runtime, Rack::Timeout, service_timeout: 2

  config.action_dispatch.show_exceptions = true
end

Rack::Timeout::Logger.logger = logger

Notable.slow_request_threshold = 1
