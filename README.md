# Golden::Objects

Provide ruby classes and modules help you build business logics as ruby components.

Let's compose business logics as ruby components to improve efficiency of maintenance.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'golden-objects'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install golden-objects

## Usage

Create your class and inherite appropriate golden object directly or though another class.

```
class ApplicationPresenter < Golden::ApplicationPresenter
  include Rails.application.routes.url_helpers
end

class CartPresenter < ApplicationPresenter
  attr_accessor :product_variants

  def line_items_presenter
    @line_items_presenter ||= CartLineItemPresenter.all(product_variants: product_variants)
  end
end
```

And put into suggested pathes.

* business logic classes => app/components
* data model logic classes => app/objects

Grouping classes by multi layers of folders are also suggested.

```
app/components/[major business logic]/[secondary business logic]/xxx_xxx.rb
app/objects/[major data model logic]/[secondary data model logic]/xxx_xxx.rb
```

For example:

```
app/components/identity/profile/update_form.rb
app/components/frontend/popup_cart/main_presenter.rb
app/objects/orders/line_item/create_operator.rb
app/objects/orders/create_operator.rb
```

## Modules

4 kinds of modules are provided.

* attribute accessors
* active model concerns
* active record concerns
* action view extensions

## Objects

3 groups of objects are provided.

* Application objects
  * Golden::ApplicationCalculator
  * Golden::ApplicationContext
  * Golden::ApplicationForm
  * Golden::ApplicationGenerator
  * Golden::ApplicationOperator
  * Golden::ApplicationPresenter
  * Golden::ApplicationService
  * Golden::ApplicationTransformer
* Form objects
  * Golden::ActionFormOperator
  * Golden::ActiveRecordForm
  * Golden::SingleFormPresenter
* Query objects
  * Golden::QueryContext
  * Golden::QueryForm
  * Golden::QueryFormOperator
  * Golden::QueryResultPresenter

## Action View

require extension for actionview in controller of rails.

```
require 'golden/action_view/extension'

class ApplicationController < ActionController::Base
  helper ::Golden::FormHelper
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/goldenio/golden-objects.
