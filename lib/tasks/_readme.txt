1. extracted the data from legacy(?) into a GED file

2. rake db:convert will create two json files: fams1 and indi1

3a. rake db:import will create people from the json file
3b. rake db:families will create the family records from json