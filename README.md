# js_assets

Gem provides a helper asset_path in javascript.

## Installation

Add gem to your Gemfile
```ruby
gem 'js_assets'
```
And run `bundle install`.

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

# License #

Copyright &copy; 2013 Zaur Abasmirzoev <<zaur.kavkaz@gmail.com>>

JsAssets is distributed under an MIT-style license. See LICENSE for
details.

