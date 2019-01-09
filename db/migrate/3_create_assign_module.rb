class CreateAssignModule < ActiveRecord::Migration[5.1]
  create_table :module_assignments do |t|
    t.references :project, index: { unique: true }
  end
end