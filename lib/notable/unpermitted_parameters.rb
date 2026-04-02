ActiveSupport::Notifications.subscribe "unpermitted_parameters.action_controller" do |_, _, _, _, payload|
  Notable.track "Unpermitted Parameters", payload[:keys].join(", ")
end
