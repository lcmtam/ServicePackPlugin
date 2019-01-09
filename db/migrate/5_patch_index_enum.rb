class PatchIndexEnum < ActiveRecord::Migration[5.1]
  def change
    add_index :enumerations, [:project_id, :name], unique: true, name: "project_id_name_index"
  end
end