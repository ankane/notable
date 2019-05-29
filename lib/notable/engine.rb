module Notable
  class Engine < ::Rails::Engine
    isolate_namespace Notable

    initializer "notable" do |app|
      if Notable.requests_enabled?
        # insert in same place as request_store
        app.config.middleware.insert_after ActionDispatch::RequestId, Notable::Middleware
        ActionDispatch::DebugExceptions.prepend Notable::DebugExceptions
      end
    end
  end
end
