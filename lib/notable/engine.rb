module Notable
  class Engine < ::Rails::Engine
    isolate_namespace Notable

    initializer "notable" do |app|
      if Notable.requests_enabled?
        # insert in same place as request_store
        app.config.middleware.insert_after ActionDispatch::RequestId, Notable::Middleware
        ActionDispatch::DebugExceptions.register_interceptor do |request, exception|
          request.env["action_dispatch.exception"] = exception
        end
      end
    end
  end
end
