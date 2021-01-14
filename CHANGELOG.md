# Change Logs

# v0.3.3

* fix typo of `total_pages`.
* Add more methods for pagination.

## v0.3.2

* Add `Golden::QueryRecordPresenter` and `Golden::QueryFormPresenter` as basic presenters.

## v0.3.1

* The argement `presenter_class` of `Golden::QueryResultPresenter.collect` should be string instead of class.

## v0.3.0

* `Golden::QueryResultPresenter`:
  * BREAKING: Change `initialize` definition.
  * Add `records`, `presenter_class` accessors.
  * Add `collect`, `paginated_array` class methods.
  * Let `presenters` can be customized.
  * Add missing `total_page` method.
* `Golden::QueryFormOperator`:
  * Add `mode` accessor and pass to form.
  * Let `query_result`, `record_presenter_class` can be customized.
* `Golden::QueryContext`:
  * Include `ActiveRecord::Sanitization::ClassMethods`.
  * Change prefered `sort` implementation.

## v0.2.0

* Add golden form builder and helper.
* Golden query context support pluck.

## v0.1.0

* Initial release.
