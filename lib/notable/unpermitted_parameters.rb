ActiveSupport::Notifications.subscribe "unpermitted_parameters.action_controller" do |name, start, finish, id, payload|
  Notable.track "Unpermitted Parameters", payload[:keys].join(", ")
end
