# frozen_string_literal: true

class ChangeModifiedByToReferenceInModificationLogs < ActiveRecord::Migration[7.0]
    def change
        remove_column :modification_logs, :modified_by, :string
        add_reference :modification_logs, :modified_by, null: false, foreign_key: { to_table: :users }
    end
end
