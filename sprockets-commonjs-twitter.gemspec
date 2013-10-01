# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "sprockets-commonjs-twitter"
  s.version     = '0.2.0.0.1'
  s.authors     = ['Michael Jackson', 'Alex MacCaw', 'Jordan Harband']
  s.email       = ['mjackson@twitter.com', 'info@eribium.org', 'ljharb@gmail.com']
  s.homepage    = ''
  s.summary     = 'Adds CommonJS support to Sprockets'
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "sprockets",     "~> 2.0"
  s.add_runtime_dependency "json",          "~> 1.8.0"
  s.add_development_dependency 'appraisal', '~> 0.5.1'
end
