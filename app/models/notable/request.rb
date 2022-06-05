module Notable
  class Request < ActiveRecord::Base
    self.table_name = "notable_requests"

    belongs_to :user, polymorphic: true, optional: true
    serialize :params, JSON

    before_save :truncate_too_long_params

    def truncate_too_long_params
      base64_regex = /(\"data\:)(\w+\/\w+)(\;base64\,).+?(\")/
      self.params = JSON.parse(self.params.to_json.to_s.gsub(base64_regex, '\1\2\3...\4'))
    end
  end
end
