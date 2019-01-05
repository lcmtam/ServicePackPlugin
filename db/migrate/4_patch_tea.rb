class PatchTea < ActiveRecord::Migration[5.2]
  def change
    remove_column :enumerations, :parent_id, :integer
  end
end