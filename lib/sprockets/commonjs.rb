require 'sprockets'
require 'tilt'

module Sprockets
  class CommonJSTemplate < Tilt::Template
    self.default_mime_type = 'application/javascript'

    WRAPPER = <<-JAVASCRIPT.gsub(/\s+/, '')
    %s.define({
      %s: function (exports, require, module) {
        %s
      }
    });
    JAVASCRIPT

    def self.default_namespace
      'this.require'
    end

    def self.wrap(path, data, namespace=default_namespace)
      WRAPPER % [namespace, path, data]
    end

    def prepare
      @namespace = self.class.default_namespace
    end

    attr_reader :namespace

    def evaluate(scope, locals, &block)
      if wrap?(scope)
        scope.require_asset 'sprockets/commonjs'
        path = scope.logical_path.chomp('.module').inspect
        self.class.wrap(path, data, namespace)
      else
        data
      end
    end

    def wrap?(scope)
      File.extname(scope.logical_path) == '.module'
    end
  end

  register_postprocessor 'application/javascript', CommonJSTemplate
  append_path File.expand_path('../..', __FILE__)

  # This class can be used to wrap the contents of a file in a
  # string that is exported from a CommonJS module.
  #
  # Add it to your Sprockets environment:
  #
  #   sprockets_env.register_engine '.mustache', Sprockets::CommonJSExportsTemplate
  #
  # Require a file with the appropriate extension:
  #
  #   //= require my_template
  #
  # Then, in your JavaScript:
  #
  #   var template = require('my_template');
  class CommonJSExportsTemplate < CommonJSTemplate
    self.default_mime_type = 'application/javascript'

    def evaluate(scope, locals, &block)
      @data = "module.exports = #{data.to_json}"
      super
    end

    def wrap?(scope)
      true
    end
  end
end
