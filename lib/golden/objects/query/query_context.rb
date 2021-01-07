# frozen_string_literal: true

module Golden
  class QueryContext < Golden::ApplicationContext
    class << self
      def attributes
        merge_attributes!(:sort)
        accessor_attributes
      end
    end

    include ::ActiveRecord::Sanitization::ClassMethods

    attr_accessor :page, :per
    attr_accessor :sort_field, :sort_direction

    boolean_accessor :plucking
    attr_reader :pluck_fields

    def initialize(accessors = {})
      assign_attributes(accessors || {})
      @page ||= 1
      @per ||= 100
    end

    def perform(mode = :paginated, pluck: nil)
      @plucking = pluck.present?
      @pluck_fields = pluck
      send("find_#{mode}")
    end

    def sort=(values)
      return if values.blank?

      field, direction = values.to_s.split(',')
      @sort_field = field.presence&.to_sym
      @sort_direction = direction.presence&.to_sym
    end

    private

    def find_first
      return nil if invalid?

      relations.where(query_scopes).order(sort).first
    end

    def find_last
      return nil if invalid?

      relations.where(query_scopes).order(sort).last
    end

    def find_all
      return [] if invalid?

      finder = relations.where(query_scopes).order(sort).all
      find_or_pluck(finder)
    end

    def find_count
      return nil if invalid?

      relations.where(query_scopes).order(sort).count
    end

    def find_paginated
      return paginated_blank_result if invalid?

      finder = relations.where(query_scopes).order(sort).page(page).per(per)
      find_or_pluck(finder)
    end

    def paginated_blank_result
      return Kaminari.paginate_array([], total_count: 0).page(1) if ::Object.const_defined? 'Kaminari'

      raise NotImplementedError
    end

    def find_or_pluck(finder)
      return finder unless plucking?

      finder.pluck(safe_table_fields(pluck_fields) || Arel.star)
    end

    def safe_table_fields(table_and_fields)
      table_fields = table_and_fields.flat_map do |table, fields|
        table_name = send(table)&.name
        next if table_name.blank?

        fields.map { |field| [table_name, field.to_s].join('.') }
      end.compact
      Arel.sql(table_fields.join(', '))
    end

    def relations
      raise NotImplementedError, <<~ERROR
        Please define #{__method__} like
        ```
          def #{__method__}
            @#{__method__} ||= Record.joins().includes().eager_load()
          end
        ```
      ERROR
    end

    def sort
      raise NotImplementedError, <<~ERROR
        Please define #{__method__} like
        ```
          def #{__method__}
            @sort_field ||= :id
            @sort_direction ||= :desc
            @#{__method__} = send("sort_by_\#{@sort_field}")
          rescue NoMethodError
            @#{__method__} = sort_by_id
          end
        ```
        And define sort_by_xxx like
        ```
          def sort_by_id
            [
              Record.arel_table[sort_field].send(sort_direction)
            ]
          end
        ```
      ERROR
    end

    def query_scopes
      raise NotImplementedError, <<~ERROR
        Please define #{__method__} like
        ```
          def #{__method__}
            @scopes = nil
            concat_xxx_scope
            @scopes
          end
        ```
        And define concat_xxx_scope like
        ```
          def concat_xxx_scope
            scope = Record.arel_table[:xxx_number].eq(@xxx_number)
            scopes_and(scope)
          end
        ```
      ERROR
    end

    def scopes_and(scope)
      @scopes = @scopes ? @scopes.and(scope) : scope
    end
  end
end
