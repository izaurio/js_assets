$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "js_assets/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "js_assets"
  s.version     = JsAssets::VERSION
  s.authors     = ["Zaur Abasmirzoev"]
  s.email       = ["zaur.kavkaz@gmail.com"]
  s.license     = 'MIT'
  s.homepage    = "https://github.com/kavkaz/js_assets"
  s.summary     = "Javascript helper"
  s.description = "Provide asset_path helper in javascript"
  s.require_paths = ["lib"]
  s.files = `git ls-files`.split("\n")
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails'
  s.add_dependency 'sprockets', '>= 3.0'

  s.add_development_dependency "yard"
end
