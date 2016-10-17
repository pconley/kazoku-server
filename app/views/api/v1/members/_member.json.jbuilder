json.extract! member, :id, :key, :famc_key, :fams_keys,
	:last_name, :first_name, :middle_name, :common_name, :full_name,
	:parents, :children, :siblings, :spouses,
	:birth, :death, :gender,
	:created_at, :updated_at
json.url member_url(member, format: :json)