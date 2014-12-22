module Notable
  module ValidationErrors
    extend ActiveSupport::Concern

    included do
      after_validation :track_validation_errors
    end

    def track_validation_errors
      if errors.any?
        Notable.track "Validation Errors", "#{self.class.name}: #{errors.full_messages.join(", ")}"
      end
    end
  end
end

ActiveRecord::Base.send(:include, Notable::ValidationErrors)
