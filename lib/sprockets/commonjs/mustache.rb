require 'sprockets'
require 'tilt'
require 'json'

module Sprockets
  class CommonJS < Tilt::Template
    class Mustache < CommonJS

      private

      def commonjs_module?(scope)
        scope.pathname.basename.to_s =~ /\.mustache\Z/
      end

      def wrap(scope, data)
        super(scope, "module.exports = #{data.to_json}")
      end

    end
  end
end
