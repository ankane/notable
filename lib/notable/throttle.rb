ActiveSupport::Notifications.subscribe "rack.attack" do |_name, _start, _finish, _request_id, req|
  request = req.is_a?(Hash) ? req[:request] : req

  if [:blacklist, :blocklist, :throttle].include?(request.env["rack.attack.match_type"])
    Notable.track "Throttle", request.env["rack.attack.matched"]
  end
end

# TODO uncomment in 0.7.0
# ActiveSupport::Notifications.subscribe "rate_limit.action_controller" do |_|
#   Notable.track "Throttle", "throttle note"
# end
