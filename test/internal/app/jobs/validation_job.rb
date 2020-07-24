class ValidationJob < ActiveJob::Base
  def perform
    User.create
  end
end
