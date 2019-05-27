ActiveSupport::Notifications.subscribe "rack.attack" do |_name, _start, _finish, _request_id, req|
  request = req.is_a?(Hash) ? req[:request] : req

  if [:blacklist, :throttle].include?(request.env["rack.attack.match_type"])
    Notable.track "Throttle", request.env["rack.attack.matched"]
  end
end
