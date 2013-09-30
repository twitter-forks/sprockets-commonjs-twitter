require 'sprockets/commonjs'
require 'sprockets/commonjs/mustache'

if defined?(Rails)
  module Sprockets
    class CommonJS

      class Engine < ::Rails::Engine
        initializer :setup_commonjs, :after => "sprockets.environment", :group => :all do |app|
          app.assets.register_postprocessor 'application/javascript', CommonJS
          app.assets.register_engine '.mustache', CommonJS::Mustache
        end
      end

    end
  end
end