class PatchCommentTimeEntry < ActiveRecord::Migration[5.1]
  def change
    add_column :time_entries, :comment, :string, limit: 255 
  end
end