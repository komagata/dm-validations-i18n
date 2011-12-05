# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "data_mapper/validations/i18n"
require "data_mapper/validations/i18n/version"

Gem::Specification.new do |s|
  s.name        = "dm-validations-i18n"
  s.version     = DataMapper::Validations::I18n::VERSION
  s.authors     = ["Masaki Komagata"]
  s.email       = ["komagata@gmail.com"]
  s.homepage    = "https://github.com/komagata/dm-validations-i18n"
  s.summary     = %q{Localize error messages in dm-validations.}
  s.description = %q{Localize error messages in dm-validations.}

  s.rubyforge_project = "dm-validations-i18n"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "shoulda"
  s.add_runtime_dependency "dm-validations"
end
