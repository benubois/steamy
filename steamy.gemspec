# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "steamy/version"

Gem::Specification.new do |s|
  s.name        = "steamy"
  s.version     = Steamy::VERSION
  s.authors     = ["Ben Ubois"]
  s.email       = ["ben@benubois.com"]
  s.homepage    = ""
  s.summary     = %q{Export remote MySQL Databases}
  s.description = %q{steamy exports remote MySQL databases using SequelPro saved connections.}

  s.rubyforge_project = "steamy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "plist"
end
