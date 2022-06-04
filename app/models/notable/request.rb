module Notable
  class Request < ActiveRecord::Base
    self.table_name = "notable_requests"

    belongs_to :user, polymorphic: true, optional: true
    serialize :params, JSON

    before_save :truncate_too_long_params

    def truncate_too_long_params
      params = JSON.parse(params.to_s.gsub(/\"data:.+\/.+;base64.+\"/, 'base64_image'))
    end
  end
end
