json.partial! "members/person", person: @person
json.parents @person.family.people, :id, :first_name, :last_name