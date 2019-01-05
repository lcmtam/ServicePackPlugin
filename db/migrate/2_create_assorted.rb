class CreateAssorted < ActiveRecord::Migration[5.2]
  def change
    create_table :enumerations do |t|
      t.string :name
      t.boolean :active
      t.integer :parent_id # self-ref
      t.references :project
      t.string :type
    end

    create_table :time_entries do |t|
      t.integer :activity_id
      t.references :project
      t.float :hours
      t.date :spent_on
      # t.integer :tyear, :tmonth, :tweek
      t.timestamps
    end

    create_table :projects do |t|
      t.string :name, :identifier
    end
  end
end