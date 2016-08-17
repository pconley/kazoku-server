class Person
	attr_accessor :key
	attr_accessor :name
	attr_accessor :gender
	attr_accessor :famc # where i am child
	attr_accessor :fams # where i am spouse
	def to_s
		"Person: #{name}"
	end
end

class Family
	attr_accessor :key
	attr_accessor :h_key
	attr_accessor :w_key
	attr_accessor :children
	def wife
		$inds[w_key]
	end
	def husband
		$inds[h_key]
	end
	def to_s
		"Family: #{key} #{husband.name}/#{wife.name}"
	end
end

$nextline = ""

$inds = {}
$fams = {}

def read(f)
	$nextline = f.readline
	#puts "READ: #{$nextline}"
	d, t, k = parse($nextline)
	#puts "RTRN: d:#{d} t:#{t} k:#{k}"
	return d,t,k
end

def parse(line)
	parts = line.split(' ')
	depth = parts[0]

	if parts[1] == 'HEAD'
		return depth, 'HEAD', ''
	end

	if parts[1][0] == '@'
		return depth, parts[2], parts[1]
	end

	return depth, parts[1], parts[2..10].join(' ')
end

def process_header(f)
	puts "process header"
	d, t, k = read(f)
	while d != '0' 
		# process body line here
		d, t, k = read(f)
	end
end

def process_individual(f)

	d, t, key = parse($nextline)
	p = Person.new()
	p.key = key
	#puts "process individual"
	d, t, rest = read(f)
	while d != '0' 
		p.name = rest if t=='NAME'
		p.gender = rest if t== 'SEX'
		p.fams = rest if t== 'FAMS'
		p.famc = rest if t== 'FAMC'
		d, t, rest = read(f)
	end
	$inds[key] = p
	puts "#{p}"
end

def process_family(f)
	d, t, key = parse($nextline)
	fam = Family.new()
	fam.key = key

	# puts "process family: #{$nextline}"
	d, t, rest = read(f)
	while d != '0' 
		fam.h_key = rest if t=='HUSB'
		fam.w_key = rest if t=='WIFE'
		d, t, rest = read(f)
	end
	puts fam
	$fams[key] = fam
end

def process_other(f)
	#puts "process other: #{$nextline}"
	d, t, k = read(f)
	while d != '0' 
		# process body line here
		d, t, k = read(f)
	end
end

File.open("test1.ged", "r") do |f|
	count = 0
	d, t, k = read(f)

	while d == '0'
		# puts "#{count}: #{$nextline}"
		# puts "d:#{d} t:#{t} k:#{k}"
		case t
		when "HEAD"
			process_header(f)
		when "INDI"
			count += 1
			process_individual(f)
			# break if count > 200
		when "TRLR" # trailer record
			puts "*** end of file"
			break
		when "FAM" # submitter
			process_family(f)
		when "SUBM" # submitter
			process_other(f)
		else
			process_other(f)
		end
		# process has read ahead
		d,t,k = parse($nextline)
	end
end

def father(ind)
	da_fam = $fams[ind.famc]
	da = $inds[da_fam.husband]
	puts da
	return da
end

# REPORT

puts "\n--- Report\n\n"
pjc = $inds['@I287@']
puts pjc
my_fam = $fams[pjc.fams] 
da_fam = $fams[pjc.famc]

puts "da fam = #{da_fam}"
puts "my fam = #{my_fam}"
puts $inds[my_fam.wife]
puts $inds[my_fam.husband]

$inds.each do |k,v|
	puts v if v.famc == pjc.fams
end

gjc = father(pjc)
tpc = father(gjc)
jfc = father(tpc)
pxc = father(jfc)
top = father(pxc)
