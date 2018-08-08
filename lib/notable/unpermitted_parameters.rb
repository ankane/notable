ActiveSupport::Notifications.subscribe "unpermitted_parameters.action_controller" do |_name, _start, _finish, _id, payload|
  Notable.track "Unpermitted Parameters", payload[:keys].join(", ")
end
