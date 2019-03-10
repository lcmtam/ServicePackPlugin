class TimeEntryActivitySerializer < ActiveModel::Serializer
	attributes :id, :name, :project_id, :parent_id
end