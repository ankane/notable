module Notable
  class Engine < ::Rails::Engine
    isolate_namespace Notable

    initializer "notable" do |app|
      app.config.middleware.insert_after RequestStore::Middleware, Notable::Middleware

      ActionDispatch::DebugExceptions.send(:prepend, Notable::DebugExceptions)
    end
  end
end
