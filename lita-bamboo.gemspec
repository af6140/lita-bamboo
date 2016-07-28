Gem::Specification.new do |spec|
  spec.name          = "lita-bamboo"
  spec.version       = "0.1.2"
  spec.authors       = ["Wang, Dawei"]
  spec.email         = ["dwang@entertainment.com"]
  spec.description   = "Bamboo Lita tasks"
  spec.summary       = "Bamboo build server operations"
  spec.homepage      = "https://github.com/af6140/lita-bamboo"
  spec.license       = "Apache-2.0"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.7"
  spec.add_runtime_dependency "rest-client", ">= 1.7 ", "<2.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rack", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
