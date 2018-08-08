ActiveSupport::Notifications.subscribe "rack.attack" do |_name, _start, _finish, _request_id, req|
  if [:blacklist, :throttle].include?(req.env["rack.attack.match_type"])
    Notable.track "Throttle", req.env["rack.attack.matched"]
  end
end
