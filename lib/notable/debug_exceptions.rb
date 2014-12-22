module Notable
  module DebugExceptions
    extend ActiveSupport::Concern

    included do
      alias_method_chain :render_exception, :pass
    end

    def render_exception_with_pass(env, exception)
      env["action_dispatch.exception"] = exception
      render_exception_without_pass(env, exception)
    end

  end
end
