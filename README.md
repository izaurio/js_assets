# js_assets

Gem provides a helper asset_path in javascript.

## Installation

Add gem to your Gemfile
```ruby
gem 'js_assets'
```
And run `bundle install`.

The current version supports only `Sprockets 3.x`. For `Sprockets 2.x` use version `0.0.10`
```ruby
gem 'js_assets', '<= 0.0.10'
```

## Usage

In your `application.js`
```javascript
//= require app_assets
```

This directive adds the method `asset_path` in the global scope.

Get the path to the template `app/assets/javascripts/rubrics/views/index.html` in javascript:
```javascript
var path = asset_path('rubrics/views/index.html')
// the function will return for development:
// /assets/rubrics/views/index.html
// and for production
// /assets/rubrics/views/index-5eb3bb250d5300736006c8944e436e3f.html
```

To automatically update `app_assets.js` when adding new files in `app/assets`, do the following steps. Add to `Gemfile`:
```ruby
group :development do
  gem 'guard'
  gem 'guard-shell'
end
```
 Add to `Guardfile`:
```ruby
guard :shell do
    watch(%r{^app/assets/.*}) { `rm -rf tmp/cache` }
end
```
Run the command `bundle exec` to install the gems. Before starting to develop run `guard`:
```shell
$ bundle exec guard
```
**Warning!** This may adversely affect the rate of return assets list in the development environment. Since they will be compiled at each change.

### Slim for AngularJS

For example we want to use templating [Slim](http://rubydoc.info/gems/slim/) in [AngularJS](https://angularjs.org) app. Let our templates will be in `app/assets/webapp/`. We make the following settings:
```ruby
# config/application.rb
config.assets.paths << Rails.root.join('app', 'assets', 'webapp')

# config/initizlizers/assets_engine.rb
Rails.application.assets.register_engine('.slim', Slim::Template)

# config/environments/production.rb
config.assets.precompile += ['*.html']
```

Do not forget to connect a file in your `application.js`
```javascript
//= require app_assets
```

Now for the template `app/assets/webapp/blogs/edit.html.slim` we can get a path depending on the environment:
```javascript
var path = asset_path('blogs/edit.html')
// the function will return for development:
// /assets/blogs/edit.html
// and for production
// /assets/blogs/edit-5eb3bb250d5300736006c8944e436e3f.html
```

## Settings

You can specify, for example in the initializer, which will be available in the helper `asset_path`, and which should be excluded.

To add a file to the list, use:
```ruby
JsAssets::List.allow << '*.png'
```
To exclude:
```ruby
JsAssets::List.exclude << '*.png'
```
Initially, the list is taken asset falling within the filter `app/config/environments/production.rb`
```ruby
config.assets.precompile += ['*.html']
```
By default:
```ruby
JsAssets::List.exclude = ["application.js"]
JsAssets::List.allow = ["*.html"]
```

Be careful! If the list of available `JsAssets::List.allow` get a file that is inserted directive `require app_assets`, recursion will occur as `sprockets` will calculate the md5-based content.

To determine which file name will be used (with md5 or not) use the option:
```ruby
# Generate digests for assets URLs.
config.assets.digest = true
```

# License #

Copyright &copy; 2013 Zaur Abasmirzoev <<zaur.kavkaz@gmail.com>>

JsAssets is distributed under an MIT-style license. See LICENSE for
details.

