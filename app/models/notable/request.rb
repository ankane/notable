module Notable
  class Request < ActiveRecord::Base
    self.table_name = "notable_requests"

    belongs_to :user, polymorphic: true, optional: true
    if ActiveRecord::VERSION::STRING.to_f >= 7.1
      serialize :params, coder: JSON
    else
      serialize :params, JSON
    end
  end
end
