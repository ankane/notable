module Notable
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      start_time = Notable.monotonic_time
      status, headers, body = @app.call(env)
      request_time = Notable.monotonic_time - start_time

      Safely.safely do
        if (e = env["action_dispatch.exception"]) && (!defined?(ActionController::TooManyRequests) || !e.is_a?(ActionController::TooManyRequests))
          message =
            case status.to_i
            when 404
              "Not Found"
            when 503
              "Timeout"
            else
              "Error"
            end
          Notable.track message, "#{e.class.name}: #{e.message}"
        elsif (!status || status.to_i >= 400) && !Notable.notes.any?
          Notable.track Rack::Utils::HTTP_STATUS_CODES[status.to_i]
        end

        if request_time > Notable.slow_request_threshold && status.to_i != 503
          Notable.track "Slow Request"
        end

        notes = Notable.notes
        if notes.any?
          request = ActionDispatch::Request.new(env)

          url = request.original_url

          controller = env["action_controller.instance"]
          action = controller && "#{controller.controller_path}##{controller.action_name}"
          params = controller && (controller.request.filtered_parameters.except("controller", "action") rescue nil)

          user = Notable.user_method.call(env)

          user_agent = request.user_agent
          referrer = request.referer

          if Notable.scrub_invalid_utf8
            user_agent = user_agent.scrub
            referrer = referrer.scrub
          end

          notes.each do |note|
            ip = request.remote_ip
            if ip && Notable.mask_ips
              ip = Notable.mask_ip(ip)
            end

            data = {
              note_type: note[:note_type],
              note: note[:note],
              user: user,
              action: action,
              status: status,
              params: params,
              request_id: request.uuid,
              ip: ip,
              user_agent: user_agent,
              url: url,
              referrer: referrer,
              request_time: request_time
            }
            Notable.track_request_method.call(data, env)
          end
        end
      end

      [status, headers, body]
    ensure
      Notable.clear_notes
    end
  end
end
