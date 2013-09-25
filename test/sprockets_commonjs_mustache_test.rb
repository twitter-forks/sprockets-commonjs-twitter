require 'test/unit'
require 'tempfile'
require 'sprockets-commonjs'

class SprocketsCommonjsMustacheTest < Test::Unit::TestCase

  TEST_DIR = File.expand_path('..', __FILE__)
  LIB_DIR  = File.expand_path('../lib/assets/javascripts', TEST_DIR)

  attr_reader :output

  def setup
    env = Sprockets::Environment.new
    env.register_engine '.mustache', Sprockets::CommonJS::Mustache
    env.append_path TEST_DIR
    env.append_path LIB_DIR
    outfile = Tempfile.new('sprockets-mustache-output')
    env['source_mustache.js'].write_to outfile.path
    @output = File.read outfile.path
  end

  def test_adds_commonjs_require
    assert_match %r[var require = function\(name, root\) \{], @output
  end

  def test_modularizes_mustache
    assert_match %r[this.require.define\(\{\"template\":function\(exports, require, module\)], @output
    assert_match %r[scary!], @output
  end

  def test_omits_extra_semicolon
    expected = File.read(Pathname.new(TEST_DIR) + 'expected_template.mustache.js')
    end_of_output = @output[-expected.length, expected.length]
    assert_equal expected, end_of_output
  end

  def test_has_template_path_method
    assert_equal Pathname.new(LIB_DIR), Sprockets::CommonJS::Mustache.template_path
  end

  def test_default_namespace
    assert_equal 'this.require', Sprockets::CommonJS::Mustache.default_namespace
  end

  def test_default_mime_type
    assert_equal 'application/javascript', Sprockets::CommonJS::Mustache.default_mime_type
  end

end
