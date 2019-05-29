module Notable
  class Engine < ::Rails::Engine
    isolate_namespace Notable

    initializer "notable" do |app|
      if Notable.requests_enabled?
        app.config.middleware.insert_after RequestStore::Middleware, Notable::Middleware
        ActionDispatch::DebugExceptions.prepend Notable::DebugExceptions
      end
    end
  end
end
