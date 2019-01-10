class OpenProjectLazyCreationOfTea < ActiveRecord::Migration[5.1]
	def change
		add_column :enumerations, :parent_id, :integer
	end
end