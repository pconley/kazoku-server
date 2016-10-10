json.partial! "members/person", person: @person
json.parents @person.parents, :id, :first_name, :last_name