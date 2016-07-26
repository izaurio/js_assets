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

You can look at the raw hash of assets by inspecting `JsAssets::List.fetch` on the Rails console or the global JavaScript variable, `project_assets`, in your browser's console.

## Updating after changes

js_assets would be pretty slow if it had to calculate the assets on every request! For performance reasons, js_assets therefore keeps a cache of assets and *the cache will survive app restarts*, even if you restart Spring during development. If you change js_assets' configuration or add/remove any asset files, you should delete `tmp/cache` under Rails root.

To automatically update `app_assets.js` when adding new files in `app/assets`, you can use the `guard` tool - it monitors the file system and performs actions when certain events occur. This can be useful during development.

To setup Guard, Add to `Gemfile`:
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

### Example: Reference Slim-generated HTML assets from JavaScript

For example we want to use templating [Slim](http://rubydoc.info/gems/slim/) in [AngularJS](https://angularjs.org) app. Let our templates will be in `app/assets/webapp/`. We make the following settings:

In general, the standard config to generate HTML from Slim would look something like this:

```ruby
# config/application.rb
config.assets.paths << Rails.root.join('app', 'assets', 'webapp')

# config/initizlizers/assets_engine.rb
Rails.application.assets.register_engine('.slim', Slim::Template)

# config/environments/production.rb
config.assets.precompile += ['*.html']
```

By default, js_assets will make all "*.html" assets available, so we don't have to do any special js_assets config. To reference these templates in JavaScript, just include app_assets in `application.js`.
```javascript
//= require app_assets
```

And now we get a path for these Slim-generated assets in our JavaScript! e.g. to reference the template `app/assets/webapp/blogs/edit.html.slim`:

```javascript
var path = asset_path('blogs/edit.html')
// the function will return for development:
// /assets/blogs/edit.html
// and for production
// /assets/blogs/edit-5eb3bb250d5300736006c8944e436e3f.html
```

The `asset_path` function will be available to any JavaScript, including those you've generated from other syntaxes such as CoffeeScript.

## Settings

Using `JSAssets::List`, you can specify, for example in the initializer, which assets will be available via the `asset_path` helper, and which should be excluded. By default, "*.html" is included.

You can configure this in application.rb or create an initialiser file like config/intializers/js_assets.rb and configure it there.

To add a file pattern to the list, use:
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
The default settings are:
```ruby
JsAssets::List.exclude = ["application.js"]
JsAssets::List.allow = ["*.html"]
```

And remember to delete tmp/cache.

Be careful! If the list of available `JsAssets::List.allow` get a file that is inserted directive `require app_assets`, recursion will occur as `sprockets` will calculate the md5-based content. Generally, if you are using files like "application.js" with a list of "require" directives, you should exclude them using the `.exclude` setting above.

To determine if filename will be used with md5 hashes, js_assets will use the Rails config:
```ruby
# Generate digests for assets URLs.
config.assets.digest = true
```

You can use the directive Rails `asset_host` by setting `ActionController::Base.asset_host` in the application configuration, typically in `config/environments/production.rb`:
```ruby
config.action_controller.asset_host = "assets.example.com"
```

# License #

Copyright &copy; 2013 Zaur Abasmirzoev <<zaur.kavkaz@gmail.com>>

JsAssets is distributed under an MIT-style license. See LICENSE for
details.

