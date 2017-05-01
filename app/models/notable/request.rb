module Notable
  class Request < ActiveRecord::Base
    self.table_name = "notable_requests"

    belongs_to :user, {polymorphic: true}.merge(ActiveRecord::VERSION::MAJOR >= 5 ? {optional: true} : {})
    serialize :params, JSON
  end
end
