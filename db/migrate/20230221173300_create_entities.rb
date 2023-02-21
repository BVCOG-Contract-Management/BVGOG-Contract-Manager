class CreateEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :entities do |t|
      t.text :name

      t.timestamps
    end
  end
end
