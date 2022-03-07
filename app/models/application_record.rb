# frozen_string_literal: true

# Put common code that will be inherited into all models
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def inherited(subclass)
      klass = "RailsAdmin::#{subclass.name}Admin".safe_constantize
      subclass.send :include, klass unless klass.nil?
      super
    end

    def tree_for(instance)
      where("#{table_name}.id IN (#{tree_sql_for(instance)})").order("#{table_name}.id")
    end

    def tree_sql_for(instance)
      <<-SQL
      WITH RECURSIVE search_tree(id, path) AS (
          SELECT id, ARRAY[id]
          FROM #{table_name}
          WHERE id = #{instance.id}
        UNION ALL
          SELECT #{table_name}.id, path || #{table_name}.id
          FROM search_tree
          JOIN #{table_name} ON #{table_name}.parent_id = search_tree.id
          WHERE NOT #{table_name}.id = ANY(path)
      )
      SELECT id FROM search_tree WHERE id != #{instance.id} ORDER BY path
      SQL
    end
  end
end
