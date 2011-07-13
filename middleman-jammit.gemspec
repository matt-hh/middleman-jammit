# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-jammit/version"

Gem::Specification.new do |s|
  s.name        = "middleman-jammit"
  s.version     = Middleman::Jammit::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matthias Döring"]
  s.email       = ["matt@foryourcontent.de"]
  s.homepage    = "http://rubygems.org/gems/middleman-jammit"
  s.summary     = %q{Use Jammit in Middleman}
  s.description = %q{Use Jammit in Middleman - merge multiple javascripts/stylesheets into one}

  s.rubyforge_project = "middleman-jammit"

  s.add_dependency "jammit", "~> 0.6"
  s.add_dependency "middleman", "> 1.2.7"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
