# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-actualite"
  s.version     = "0.1" 
  s.authors     = ["cedbv"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = %q{Actualité}
  s.description = %q{Actualité importante nationale avec Google News}

  s.rubyforge_project = "siriproxy-actualite"

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "httparty"
end
