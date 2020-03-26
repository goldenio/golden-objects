# frozen_string_literal: true

module Golden
  class QueryContext < Golden::ApplicationContext
    class << self
      def attributes
        merge_attributes!(:sort)
        accessor_attributes
      end
    end

    attr_accessor :page, :per
    attr_accessor :sort_field, :sort_direction

    def initialize(accessors = {})
      assign_attributes(accessors || {})
      @page ||= 1
      @per ||= 100
    end

    def perform(mode = :paginated)
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

      relations.where(query_scopes).order(sort).all
    end

    def find_count
      return nil if invalid?

      relations.where(query_scopes).order(sort).count
    end

    def find_paginated
      return paginated_blank_result if invalid?

      relations.where(query_scopes).order(sort).page(page).per(per)
    end

    def paginated_blank_result
      return Kaminari.paginate_array([], total_count: 0).page(1) if ::Object.const_defined? 'Kaminari'

      raise NotImplementedError
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
            @#{__method__} ||= Record.arel_table[@sort_field].send(@sort_direction)
          end
        ```
      ERROR
    end

    def query_scopes
      raise NotImplementedError, <<~ERROR
        Please define #{__method__} like
        ```
          def #{__method__}
            concat_xxx_scope
            @scopes
          end
        ```
        And define concat_xxx_scope like
        ```
          def concat_xxx_scope
            scope = Record.arel_table[:xxx_number].eq(@xxx_number)
            @scopes = @scopes ? @scopes.and(scope) : scope
          end
        ```
      ERROR
    end
  end
end
