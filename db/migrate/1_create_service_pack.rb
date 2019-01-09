class CreateServicePack < ActiveRecord::Migration[5.1]
  def change
    create_table :service_packs do |t|
      t.string :name, index: {unique: true}
      t.float :capacity
      t.float :used
      t.date :activation_date, :expiration_date
      t.date :deactivation_date, null: true, default: nil
      t.timestamps
    end
    create_table :sp_assign do |t|
      t.references :service_packs
      t.references :project
    end
    create_table :sp_mappings do |t|
      t.references :enumerations # TimeEntriesActivity
      t.references :service_packs
      t.integer :rate
    end
  end
end

# last resort
class CreateServicePackLink < ActiveRecord::Migration[5.1]
  def change
    create_table :sp_time_entries do |t|
      t.references :time_entries
      t.references :service_packs
    end
  end
end