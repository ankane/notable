require "bundler/setup"
Bundler.require(:development)
require "minitest/autorun"
require "minitest/pride"

Combustion.path = "test/internal"
Combustion.initialize! :active_record, :action_controller, :active_job do
  if ActiveRecord::VERSION::MAJOR < 6 && config.active_record.sqlite3.respond_to?(:represent_boolean_as_integer)
    config.active_record.sqlite3.represent_boolean_as_integer = true
  end

  config.active_job.queue_adapter = :test

  logger = ActiveSupport::Logger.new(ENV["VERBOSE"] ? STDOUT : nil)
  config.action_controller.logger = logger
  config.active_record.logger = logger
  config.active_job.logger = logger
end

Notable.slow_request_threshold = 1
