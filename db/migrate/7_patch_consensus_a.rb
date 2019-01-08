class PatchConsensusA < ActiveRecord::Migration[5.1]
	def change
		remove_column :service_packs, :deactivation_date, :date
		add_column :service_packs, :threshold1, :integer
		add_column :service_packs, :threshold2, :integer
	end
end