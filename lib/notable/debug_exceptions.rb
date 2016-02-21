module Notable
  module DebugExceptions
    def render_exception(env, exception)
      env["action_dispatch.exception"] = exception
      super
    end
  end
end
