module Notable
  module DebugExceptions
    def render_exception(request, exception, *)
      request.env["action_dispatch.exception"] = exception
      super
    end
  end
end
