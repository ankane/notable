module Notable
  module UnverifiedRequest
    extend ActiveSupport::Concern

    included do
      prepend_before_action :track_unverified_request
    end

    def track_unverified_request
      if !verified_request?
        expected = form_authenticity_token
        actual = form_authenticity_param || request.headers["X-CSRF-Token"]
        Notable.track "Unverified Request", "#{actual || "nil"} != #{expected}"
      end
    end
  end
end

ActionController::Base.send(:include, Notable::UnverifiedRequest)
