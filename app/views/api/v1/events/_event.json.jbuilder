json.extract! event, :id, :kind, :year, :month, :day

if event.member
	json.member do
		json.(event.member, :id, :first_name, :last_name, :display_range)
	end
end