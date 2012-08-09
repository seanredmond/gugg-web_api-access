# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gugg-web_api-access/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sean Redmond"]
  gem.email         = ["sredmond@guggenheim.org"]
  gem.description   = %q{Guggenheim wep api access control}
  gem.summary       = %q{Unified way to check API keys for access.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gugg-web_api-access"
  gem.require_paths = ["lib"]
  gem.version       = Gugg::WebApi::Access::VERSION

  gem.add_dependency "sequel"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "mysql"
end
