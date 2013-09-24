$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "js_assets/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "js_assets"
  s.version     = JsAssets::VERSION
  s.authors     = ["Zaur Abasmirzoev"]
  s.email       = ["zaur.kavkaz@gmail.com"]
  s.homepage    = ""
  s.summary     = "Javascript helper"
  s.description = "Provide asset_path helper in javascript"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "yard"
end
