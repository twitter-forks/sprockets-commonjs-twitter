require 'sprockets'
require 'tilt'

module Sprockets
  class CommonJS < Tilt::Template
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

    def prepare
      @namespace = self.class.default_namespace
    end

    attr_reader :namespace

    def evaluate(scope, locals, &block)
      if wrap?(scope)
        scope.require_asset 'sprockets/commonjs'
        path = scope.logical_path.chomp('.module').inspect
        WRAPPER % [namespace, path, data]
      else
        data
      end
    end

    def wrap?(scope)
      File.extname(scope.logical_path) == '.module'
    end
  end

  register_postprocessor 'application/javascript', CommonJS
  append_path File.expand_path('../..', __FILE__)
end
