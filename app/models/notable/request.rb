module Notable
  class Request < ActiveRecord::Base
    self.table_name = "notable_requests"

    belongs_to :user, polymorphic: true
    serialize :params, JSON
  end
end
