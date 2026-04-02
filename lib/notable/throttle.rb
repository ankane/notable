ActiveSupport::Notifications.subscribe "rack.attack" do |_, _, _, _, req|
  request = req.is_a?(Hash) ? req[:request] : req

  if [:blacklist, :blocklist, :throttle].include?(request.env["rack.attack.match_type"])
    Notable.track "Throttle", request.env["rack.attack.matched"]
  end
end

ActiveSupport::Notifications.subscribe "rate_limit.action_controller" do |_, _, _, _, _|
  Notable.track "Throttle", "throttle note"
end
